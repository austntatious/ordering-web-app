class StripeConnectWorker
  include Sidekiq::Worker

  def perform(restaurant_id)
    restaurant = Restaurant.find(restaurant_id)
    begin
      acc = Stripe::Account.create(
        :country => "US",
        :managed => false,
        :email => restaurant.owner_mail
      )
      if acc.id
        restaurant.update_column :stripe_destination, acc.id
      end
    rescue
      Notifier.connect_stripe(restaurant).deliver
    end
  end
end
