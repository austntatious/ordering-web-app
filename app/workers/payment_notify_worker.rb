class PaymentNotifyWorker
  include Sidekiq::Worker

  def perform(order_id)
    Order.find(order_id).notify_payed
  end
end
