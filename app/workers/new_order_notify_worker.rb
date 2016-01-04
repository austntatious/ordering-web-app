class NewOrderNotifyWorker
  include Sidekiq::Worker

  def perform(order_id)
    # send notification about newly created order
    Order.find(order_id).notify_created
  end
end
