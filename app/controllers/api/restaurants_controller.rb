class Api::RestaurantsController < Api::ApiController
	respond_to :json

	api! 'Returns the complete list of restaurants'
	param :location, :number, 'Location ID'
	def index
		@restaurants = Restaurant.joins(:locations).where('locations.id = ?', params[:location])
		respond_with @restaurants
	end
end
