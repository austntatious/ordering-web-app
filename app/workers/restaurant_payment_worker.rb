class RestaurantPaymentWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find_by_id(order_id)
    unless order.nil?
      restaurant = order.get_restaurant
      unless restaurant.nil?
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
        Stripe::Transfer.create(
          :amount => (order.restaurant_price * 100).round,
          :currency => "usd",
          :recipient => restaurant.stripe_recipient_id,
          :description => "Transfer for order #{order.id} from StreetEats"
        )
      end
    end
  end
end
