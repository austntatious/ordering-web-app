require 'sms_api'

class Order < ActiveRecord::Base
  belongs_to :user
  has_many :line_items

  after_commit :create_notification

  validates :address, :presence => true

  state_machine :status, :initial => :pending do
    event :pay do
      transition :pending => :payed
    end

    after_transition :pending => :payed do |order, transition|
      PaymentNotifyWorker.perform_async order.id
    end
    state :payed
  end

  def create_notification
    NewOrderNotifyWorker.perform_async self.id
  end

  def notify_created
    notify "Your order ##{id} on streeteats.com is successfully created", "Order ##{id} on streeteats.com is created"
    Notifier.notify_payed(self).deliver
    Notifier.notify_payed_admin(self).deliver
  end

  def notify_payed
    notify "Your order ##{id} on streeteats.com is payed now", "Order ##{id} on streeteats.com is payed now"
    Notifier.notify_payed(self).deliver
    Notifier.notify_payed_admin(self).deliver
  end

  def notify(user_text, admin_text)
    SmsApi.send_sms user.phone, user_text
    admin_phone = Setting.get 'Admin phone'
    SmsApi.send_sms admin_phone, admin_text
  end

  def total_price
    line_items.map { |li| li.total_price }.sum
  end
end
