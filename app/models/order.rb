require 'sms_api'

class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  has_many :line_items

  after_commit :create_notification
  before_create :check_order_creation_availability

  validates :address, :contact_name, :contact_phone, :presence => true

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
      PaymentNotifyWorker.perform_async order.id
    end

    state :payed
    state :cancelled
    state :completed
  end

  def check_order_creation_availability
    unless Setting.can_get_orders?
      self.errors.add(:base, 'Ordering is unavailable now')
      return false
    end
  end

  def create_notification
    NewOrderNotifyWorker.perform_async self.id
  end

  def build_content_string
    parts = []
    line_items.each do |li|
      parts << "#{li.product.name} : #{li.count}"
    end
    parts.join(';')
  end

  def notify_created
    notify "Your order ##{id} on streeteats.com is successfully created", "Order ##{id} on streeteats.com is created"
    Notifier.notify_payed(self).deliver
    Notifier.notify_payed_admin(self).deliver
  end

  def notify_payed
    notify "Your order ##{id} on streeteats.com is payed now", "Order ##{id} on streeteats.com is payed now. Order content: #{build_content_string}", "New order ##{id} from streeteats.com. Order content: #{build_content_string}"
    Notifier.notify_payed(self).deliver
    Notifier.notify_payed_admin(self).deliver
  end

  def notify(user_text, admin_text, restaurant_text = '')
    SmsApi.send_sms user.phone, user_text
    admin_phone = Setting.get 'Admin phone'
    SmsApi.send_sms admin_phone, admin_text
    restaurant = Restaurant.find_by_id(self.get_restaurant)
    unless restaurant.nil?
      SmsApi.send_sms restaurant.phone, restaurant_text
    end
  end

  def total_price
    line_items.map { |li| li.total_price }.sum
  end

  def get_restaurant
    line_items.first.product.get_restaurant
  end
end
