class PaymentNotifyWorker
  include Sidekiq::Worker

  def perform(order_id)
    # send notification on order payment
    Order.find(order_id).notify_payed
  end
end
