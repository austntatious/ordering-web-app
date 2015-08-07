class Admin::RestaurantsController < AdminController
  before_action :set_restaurant, only: [ :edit, :destroy, :update ]

  def index
    @restaurants = Restaurant.search(params[:search]).includes(:locations, :restaurant_type).order(sort_order).page(params[:page]).per(20)
  end

  def new
    @restaurant = Restaurant.new
  end

  def edit
  end

  def destroy
    @restaurant.destroy
    redirect_to admin_restaurants_path
  end

  def update
    if @restaurant.update(restaurant_params)
      redirect_to admin_restaurants_path
    else
      render :edit
    end
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to admin_restaurants_path
    else
      render :edit
    end
  end

  protected

    def sort_column
      Restaurant.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:name, :img, :phone, :work_time, :recipient_name, :recipient_type,
        :accept_orders_time, :restaurant_type_id, :address,
        :recipient_bank_account_country, :recipient_bank_account_routing_number,
        :stripe_destination, :owner_mail,
        :recipient_bank_account_account_number, :stripe_recipient_id, :location_ids => [],
        :categories_attributes => [
          :id, :name, :_destroy,
          :products_attributes => [
            :id, :category_id, :name, :price, :description, :toppings_limit, :_destroy,
            :product_options_attributes => [ :id, :name, :price, :_destroy ]
          ]
        ])
    end
end
