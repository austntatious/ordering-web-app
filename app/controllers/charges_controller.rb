class ChargesController < ApplicationController
  def create
    # Amount in cents
    @order = Order.find(params[:order_id])
    @amount = (@order.total_price * 100).round

    # customer = Stripe::Customer.create(
    #   :email => current_user.id,
    #   :card  => params[:stripeToken]
    # )
    customer = Stripe::Customer.retrieve(current_user.client_id)

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => "Order ##{@order.id}",
      :currency    => 'usd'
    )

    unless charge.nil?
      @order.pay!
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end

  def charge_card
    @credit_card = current_user.credit_cards.find_by_id(params[:id])
    unless @credit_card.nil?

    end

  end
end
