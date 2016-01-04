#
# order processing controller
#
class OrdersController < ApplicationController
  before_filter :check_user_auth

  # Require login to place an order
  def check_user_auth
    unless user_signed_in?
      session[:redirect_to_order] = 1
      redirect_to account_path
      return
    end
  end

  # show new order form
  def new
    @hide_footer = true
    if @current_cart.empty? #don't allow this for empty cart
      redirect_to root_path, :notice => 'Your cart is empty'
      return
    end
    @order = Order.new(:contact_name => current_user.name, :contact_phone => current_user.phone, :user => current_user)
    @restaurant = Restaurant.find(@current_cart.get_restaurant)
  end

  # process with new order creation
  def create
    @order = Order.new(order_params)
    @order.order_cart @current_cart
    if @order.payed? #order can be payed during creation with bonus account money
      @order_payed_now = true
    end
    if @order.save #order created successfully
      # disallow user to use same discount coupon twice
      @current_cart.mark_coupon_used current_user
      # create new empty cart
      create_cart
      # ask for confirmation code if enabled in settings
      if Setting::get('Enable phones confirmation') == '1'
        unless current_user.has_confirmed_phone
          current_user.genarate_phone_confirmation_code order.contact_phone
        end
      end
      redirect_to order_url(@order)
    else
      # order creation failed, show the 'new order' form again
      @restaurant = Restaurant.find(@current_cart.get_restaurant)
      render 'new'
    end
  end

  # show order info
  def show
    @order = current_user.orders.find(params[:id])
    @restaurant = Restaurant.find(@order.get_restaurant)
  end

  # show orders list for current user
  def index
    @orders = current_user.orders.reorder('created_at DESC').page(params[:page]).per(10)
  end

  # make order payment
  def pay
    @order = current_user.orders.find(params[:id])
    # assign saved credit card to order
    @order.credit_card_id = params[:credit_card_id]
    @order.save
    # pay with saved card
    unless @order.errors.any?
      @order.process_payment
    end
    if @order.errors.any?
      redirect_to @order, warning: @order.errors
    else
      @order_payed_now = true
      redirect_to @order
    end
  end

  private

    def order_params
      result = params.require(:order).permit(:address, :driver_instructions, :restaurant_instructions, :contact_name, :contact_phone, :money_from_account)
      result[:user_id] = current_user.id
      result[:credit_card_id] = params[:credit_card_id]
      result[:location_id] = @current_cart.location_id
      result
    end
end
