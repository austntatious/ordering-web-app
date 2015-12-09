class Api::CategoriesController < Api::ApiController
	respond_to :json

	api! 'Provides food categories list for a specified restaurant'
	param :restaurant, :number, 'Restaurant ID'
	def index
		@categories = Category.where(restaurant_id: params[:restaurant])
		respond_with @categories
	end
end

