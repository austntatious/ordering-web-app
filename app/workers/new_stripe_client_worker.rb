class NewStripeClientWorker
  include Sidekiq::Worker

  def perform(user_id)
    # create stripe customer for newly created user
    user = User.find_by_id(user_id)
    unless user.nil?
      customer = Stripe::Customer.create(
        :email => user.email
      )
      unless customer.id.nil?
        user.update_attribute :client_id, customer.id
      end
    end
  end
end
