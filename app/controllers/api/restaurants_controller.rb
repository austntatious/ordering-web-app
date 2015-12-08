class Api::RestaurantsController < Api::ApiController
	respond_to :json

	def index
		@restaurants = Restaurant.all
		respond_with @restaurants
	end
end
