class RestaurantPaymentWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find_by_id(order_id)
    unless order.nil?
      restaurant_id = order.get_restaurant
      unless restaurant_id.nil?
        restaurant = Restaurant.find_by_id(restaurant_id)
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
          :amount => (order.restaurant_price * 100).round,
          :currency => "usd",
          :recipient => restaurant.stripe_recipient_id,
          :description => "Transfer for order #{order.id} from StreetEats"
        )
        if transfer['failure_code'].nil?
          order.success_transfer = true
        else
          order.success_transfer = false
          order.transfer_error_message = "#{transfer['failure_code']} - #{transfer['failure_message']}"
        end
      end
    end
  end
end
