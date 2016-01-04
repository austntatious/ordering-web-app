#
# Standard resource controller
# app using only show method
#
class CartsController < ApplicationController
  respond_to :js, :html

  private

    def cart_params
      params.require(:cart).permit(:user_id)
    end
end

