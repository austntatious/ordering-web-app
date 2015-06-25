require 'sms_api'

class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :credit_card
  belongs_to :restaurant
  belongs_to :location
  has_many :line_items

  after_commit :create_notification, :on => [:create]
  after_commit :mailchimp_export, :on => [:create]
  after_create :withdraw_balance
  after_create :process_payment
  before_create :check_order_creation_availability
  before_create :set_delivery_fee
  before_save :validate_card
  before_save :validate_money_from_account
  before_save :set_restaurant

  validates :address, :contact_name, :contact_phone, :credit_card_id, :presence => true

  STATUSES = ['pending', 'payed', 'cancelled']

  state_machine :status, :initial => :pending do
    event :pay do
      transition :pending => :payed
    end

    event :complete do
      transition :payed => :completed
    end

    event :cancel do
      transition any => :cancelled
    end

    after_transition :pending => :payed do |order, transition|
      Refferal::make_bonus order.user
      PaymentNotifyWorker.perform_async order.id
      RestaurantPaymentWorker.perform_async order.id
    end

    state :payed
    state :cancelled
    state :completed
  end

  def withdraw_balance
    if self.money_from_account > 0
      ActiveRecord::Base.transaction do
        self.user.update_attribute :balance, self.user.balance - self.money_from_account
        AccountTransaction.create({
          :kind => AccountTransaction::KIND_ORDER_PAY,
          :user_id => self.user_id,
          :order_id => self.id,
          :amount => self.money_from_account
        })
      end
    end
  end

  def process_payment
    credit_card = self.user.credit_cards.find_by_id(self.credit_card_id)
    unless credit_card.nil?
      begin
        charge = Stripe::Charge.create(
          :customer => self.user.client_id,
          :amount => (self.total_price * 100).round,   # payment should be in cents
          :description => "Order ##{self.id}",
          :currency => 'usd',
          :source => credit_card.stripe_id
        )
        unless charge.nil?
          self.pay!
        end
      rescue Stripe::CardError => e
        self.errors.add :base, e.message
      end
    end
  end

  def validate_card
    unless self.user.credit_cards.map { |cc| cc.id }.include? self.credit_card_id
      self.errors.add :base, 'Invalid credit card'
      return false
    end
  end

  def validate_money_from_account
    if self.money_from_account > 0
      if self.user.balance < self.money_from_account
        self.money_from_account = self.user.balance
      end
      if self.money_from_account > self.total_price + self.money_from_account
        self.money_from_account = self.total_price + self.money_from_account
      end
    end
  end

  def order_cart(cart)
    self.line_items = cart.line_items
    if cart.coupon_applied?
      self.coupon_code = cart.coupon.code
      self.coupon_discount = cart.coupon.value
    end
  end

  def products_price
    self.line_items.map { |li| li.total_price }.sum
  end

  def self.get_delivery_fee(user)
    result = 4.0
    fee = Setting.get_float('Delivery fee')
    max_sum = Setting.get_float('Order sum limit before 2x delivery')
    if user.current_cart.products_price > max_sum
      fee = fee * 2
    end
    result = fee
    unless user.nil?
      if user.orders.count == 0 && !user.ref_id.nil?
        result = 0
      end
    end
    result
  end

  def self.get_tax_amount
    result = 0
    tax = Setting.get('Tax')
    unless tax.blank?
      result = tax.to_f / 100
    end
    result.round(2)
  end

  def set_delivery_fee
    self.delivery_fee = Order.get_delivery_fee(self.user)
  end

  def check_order_creation_availability
    unless Setting.can_get_orders?
      self.errors.add(:base, 'Ordering is unavailable now')
      return false
    end
  end

  def set_restaurant
    self.restaurant_id = self.get_restaurant
  end

  def create_notification
    NewOrderNotifyWorker.perform_async self.id
  end

  def build_content_string
    parts = []
    line_items.each do |li|
      if li.product_options.any?
        str = "#{li.product.name} (#{li.product_options.map { |po| po.name }.join(', ')}) : #{li.count}"
      else
        str = "#{li.product.name} : #{li.count}"
      end
      parts << str
    end
    parts.join(';')
  end

  def notify_created
    notify "Your order ##{id} on streeteats.com is successfully created", "Order ##{id} from #{self.get_restaurant_name} on streeteats.com is created. Name: #{self.contact_name}. Phone: #{self.contact_phone}. Address: #{self.address}. Instructions: #{self.driver_instructions}. Content: #{build_content_string}"
    Notifier.notify_created(self).deliver
    Notifier.notify_created_admin(self).deliver
  end

  def notify_payed
    notify "Your order ##{id} on streeteats.com is payed now", "Order ##{id} from #{self.get_restaurant_name} on streeteats.com is payed now. Name: #{self.contact_name}. Phone: #{self.contact_phone}. Address: #{self.address}. Instructions: #{self.driver_instructions}. Content: #{build_content_string}"
    #, "New order ##{id} from streeteats.com. Order content: #{build_content_string}"
    Notifier.notify_payed(self).deliver
    Notifier.notify_payed_admin(self).deliver
  end

  def notify(user_text, admin_text, restaurant_text = '')
    # SmsApi.send_sms user.phone, user_text
    admin_phone = Setting.get 'Admin phone'
    SmsApi.send_sms admin_phone, admin_text
    restaurant = Restaurant.find_by_id(self.get_restaurant)
    unless restaurant.nil?
      SmsApi.send_sms restaurant.phone, restaurant_text
    end
  end

  def total_price
    df = self.delivery_fee
    if df == 0
      df = Order.get_delivery_fee(self.user)
    end
    restaurant_price + tax_price + df - coupon_discount - money_from_account
  end

  def restaurant_price
    line_items.map { |li| li.total_price }.sum
  end

  def tax_price
    restaurant_price * Order.get_tax_amount
  end

  def get_restaurant_name
    restaurant_id = self.get_restaurant
    name = ""
    unless restaurant_id.nil?
      name = Restaurant.find_by_id(restaurant_id).try(:name) || ""
    end
    name
  end

  def get_restaurant
    nil
    if line_items.any?
      line_items.first.product.get_restaurant
    end
  end

  def pay_restaurant_comission
    restaurant_id = self.get_restaurant
    unless restaurant_id.nil?
      restaurant = Restaurant.find_by_id(restaurant_id)
      begin
        if restaurant.stripe_recipient_id.blank?
          rc = Stripe::Recipient.create(
            :name => restaurant.recipient_name,
            :type => restaurant.recipient_type,
            :bank_account => {
              :country => restaurant.recipient_bank_account_country,
              :routing_number => restaurant.recipient_bank_account_routing_number,
              :account_number => restaurant.recipient_bank_account_account_number
            }
          )
          restaurant.stripe_recipient_id = rc['id']
          restaurant.save
        end
        transfer = Stripe::Transfer.create(
          :amount => (self.restaurant_price * 100).round,
          :currency => "usd",
          :recipient => restaurant.stripe_recipient_id,
          :description => "Transfer for order #{self.id} from StreetEats"
        )
        if transfer['failure_code'].nil?
          self.success_transfer = true
        else
          self.success_transfer = false
          self.transfer_error_message = "#{transfer['failure_code']} - #{transfer['failure_message']}"
        end
      rescue Exception => e
        self.success_transfer = false
        self.transfer_error_message = e.message
      end
      self.save
    end
  end

  def mailchimp_export
    MailChimpWorker.perform_async self.id
  end
end
