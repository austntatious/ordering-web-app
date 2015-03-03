class ChargesController < ApplicationController
  def create
    # Amount in cents
    @order = Order.find(params[:order_id])
    @amount = @order.total_price * 100

    customer = Stripe::Customer.create(
      :email => current_user.id,
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => "Order ##{@order.id}",
      :currency    => 'usd'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end
end
