require 'sms_api'

class Order < ActiveRecord::Base
  belongs_to :user
  has_many :line_items

  validates :address, :presence => true

  state_machine :status, :initial => :pending do
    event :pay do
      transition :pending => :payed
    end

    after_transition :pending => :payed do |order, transition|
      order.notify_payed
    end
    state :payed
  end

  def notify_payed
    notify "Your order ##{id} on streeteats.com is payed now", "Order ##{id} on streeteats.com is payed now"
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
