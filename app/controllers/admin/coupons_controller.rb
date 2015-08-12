class Admin::CouponsController < AdminController
  before_action :set_coupon, only: [ :edit, :destroy, :update ]
  def index
    @coupons = Coupon.search(params[:search]).order(sort_order).page(params[:page]).per(20)
  end

  def new
    @coupon = Coupon.new
    add_breadcrumb 'New', new_admin_coupon_path
  end

  def edit
    add_breadcrumb 'Edit', edit_admin_coupon_path(@coupon)
  end

  def destroy
    @coupon.destroy
    redirect_to admin_coupons_path
  end

  def update
    if @coupon.update(coupon_params)
      redirect_to admin_coupons_path
    else
      render :edit
    end
  end

  def create
    @coupon = Coupon.new(coupon_params)
    if @coupon.save
      redirect_to admin_coupons_path
    else
      render :edit
    end
  end

  protected

    def sort_column
      Coupon.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def set_coupon
      @coupon = Coupon.find(params[:id])
    end

    def coupon_params
      params.require(:coupon).permit(:code, :value, :min_price, :valid_till)
    end

    def add_ctl_breadcrumb
      add_breadcrumb 'Coupons', admin_coupons_path
    end
end
