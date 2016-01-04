#
# Standard resource controller
#
class CategoriesController < ApplicationController

  private

    def category_params
      params.require(:category).permit(:name, :restaurant_id)
    end
end

