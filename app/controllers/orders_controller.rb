class OrdersController < InheritedResources::Base
  before_filter :check_user_auth

  def check_user_auth
    unless user_signed_in?
      session[:redirect_to_order] = 1
      redirect_to account_path
      return
    end
  end

  def new
    @hide_footer = true
    if @current_cart.empty?
      redirect_to root_path, :notice => 'Your cart is empty'
      return
    end
    @order = Order.new(:contact_name => current_user.name, :contact_phone => current_user.phone, :user => current_user)
    @restaurant = Restaurant.find(@current_cart.get_restaurant)
  end

  def create
    @order = Order.new(order_params)
    @order.order_cart @current_cart
    if @order.payed?
      @order_payed_now = true
    end
    if @order.save
      @current_cart.mark_coupon_used current_user
      create_cart
      if Setting::get('Enable phones confirmation') == '1'
        unless current_user.has_confirmed_phone
          current_user.genarate_phone_confirmation_code order.contact_phone
        end
      end
      redirect_to order_url(@order)
    else
      @restaurant = Restaurant.find(@current_cart.get_restaurant)
      render 'new'
    end
  end

  def show
    @order = Order.find(params[:id])
    @restaurant = Restaurant.find(@order.get_restaurant)
    if @order.user_id != current_user.id
      redirect_to root_path
      return
    end
  end

  def index
    @orders = current_user.orders.reorder('created_at DESC').page(params[:page]).per(10)
  end

  def pay
    @order = Order.find(params[:id])
    @order.credit_card_id = params[:credit_card_id]
    @order.save
    unless @order.errors.any?
      @order.process_payment
    end
    if @order.errors.any?
      redirect_to @order, :warning => @order.errors
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

