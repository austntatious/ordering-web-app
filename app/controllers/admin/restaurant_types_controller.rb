class Admin::RestaurantTypesController < AdminController
  before_action :set_restaurant_type, only: [ :edit, :destroy, :update ]
  def index
    @restaurant_types = RestaurantType.search(params[:search]).order(sort_order).page(params[:page]).per(20)
  end

  def edit
  end

  def new
    @restaurant_type = RestaurantType.new
  end

  def destroy
    @restaurant_type.destroy
    redirect_to admin_restaurant_types_path
  end

  def update
    if @restaurant_type.update(restaurant_type_params)
      redirect_to admin_restaurant_types_path
    else
      render :edit
    end
  end

  protected

    def sort_column
      RestaurantType.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def set_restaurant_type
      @restaurant_type = RestaurantType.find(params[:id])
    end

    def restaurant_type_params
      params.require(:restaurant_type).permit(:name)
    end
end
