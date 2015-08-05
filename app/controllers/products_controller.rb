class ProductsController < ApplicationController

  private

    def product_params
      params.require(:product).permit(:name, :price, :description)
    end
end

