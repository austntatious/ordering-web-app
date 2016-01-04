class RestaurantPaymentWorker
  include Sidekiq::Worker

  def perform(order_id)
    # pay money for restaurant
    order = Order.find_by_id(order_id)
    unless order.nil?
      order.pay_restaurant_comission
    end
  end
end
