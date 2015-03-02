class RestaurantsController < InheritedResources::Base

  private

    def restaurant_params
      params.require(:restaurant).permit(:name, :img)
    end
end

