#
# Controller for processing stripe charges
#
class ChargesController < ApplicationController
  def create
    # Load order and calculate amount in cents
    @order = Order.find(params[:order_id])
    @amount = (@order.total_price * 100).round

    # load stripe customer (app creates it for every user)
    customer = Stripe::Customer.retrieve(current_user.client_id)

    # create charge in stripe
    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => "Order ##{@order.id}",
      :currency    => 'usd'
    )

    unless charge.nil?
      @order.pay! #change order status if charge was processed successfully
    end

  rescue Stripe::CardError => e # show error if appeared
    flash[:error] = e.message
    redirect_to charges_path
  end

end
