class Admin::OrdersController < AdminController
  before_action :set_order, only: [ :edit, :destroy, :update, :show ]

  def index
    @orders = Order.search(params[:search]).includes(:user, :restaurant, :location)
    unless params[:restaurant_id].blank?
      @orders = @orders.where(restaurant_id: params[:restaurant_id])
    end
    unless params[:user_id].blank?
      @orders = @orders.where(user_id: params[:user_id])
    end
    unless params[:date_from].blank?
      @orders = @orders.where('created_at >= ?', params[:date_from])
    end
    unless params[:date_to].blank?
      @orders = @orders.where('created_at <= ?', params[:date_to])
    end
    @orders = @orders.reorder('orders.' + sort_order).page(params[:page]).per(20)
    respond_to do |format|
      format.html
      format.csv { send_data @orders.to_csv(col_sep: ';') }
    end
  end

  def new
    @order = Order.new
    add_breadcrumb 'New', new_admin_order_path
  end

  def edit
    add_breadcrumb 'Edit', edit_admin_order_path(@order)
  end

  def show
    add_breadcrumb 'Details', new_admin_order_path
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

    def add_ctl_breadcrumb
      add_breadcrumb 'Orders', admin_orders_path
    end
end
