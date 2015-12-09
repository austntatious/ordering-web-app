class Api::ProductsController < Api::ApiController
	respond_to :json

	api! 'Provides products list for a specified category'
	param :category, :number, 'Category ID'
	def index
		@products = Product.where(category_id: params[:category])
		respond_with @products
	end
end

