class CartsController < InheritedResources::Base

  private

    def cart_params
      params.require(:cart).permit(:user_id)
    end
end

