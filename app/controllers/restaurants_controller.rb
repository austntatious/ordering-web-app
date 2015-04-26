class RestaurantsController < InheritedResources::Base
  def show
    @restaurant = Restaurant.find params[:id]
    @restaurant.set_seo_data @seo
  end

  private

    def restaurant_params
      params.require(:restaurant).permit(:name, :img)
    end
end

