class OrdersController < InheritedResources::Base
  before_filter :check_user_auth

  def check_user_auth
    unless user_signed_in?
      redirect_to account_path
      return
    end
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.line_items = @current_cart.line_items
    if @order.save
      create_cart
      redirect_to @order
    else
      render 'new'
    end
  end

  def show
    @order = Order.find(params[:id])
    if @order.user_id != current_user.id
      redirect_to root_path
      return
    end
  end

  private

    def order_params
      result = params.require(:order).permit(:address)
      result[:user_id] = current_user.id
      result
    end
end

