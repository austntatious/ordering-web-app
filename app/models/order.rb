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
      SmsApi.send_sms("+66973497412", "Your order ##{order.id} on streeteats.com is payed now")
    end

    state :payed
  end

  def total_price
    line_items.map { |li| li.total_price }.sum
  end
end
