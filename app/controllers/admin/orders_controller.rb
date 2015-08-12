class Admin::OrdersController < AdminController
  before_action :set_order, only: [ :edit, :destroy, :update, :show ]

  def index
    @orders = Order.search(params[:search]).includes(:user, :restaurant, :location).reorder('orders.' + sort_order).page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.csv { send_data @orders.to_csv }
    end
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def show
  end

  def destroy
    @order.destroy
    redirect_to admin_orders_path
  end

  def update
    if @order.update(order_params)
      redirect_to admin_orders_path
    else
      render :edit
    end
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to admin_orders_path
    else
      render :edit
    end
  end

  protected

    def sort_column
      Order.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:user_id, :address, :driver_instructions, :status, :contact_name, :contact_phone,
        :restaurant_instructions, :delivery_fee)
    end
end
