class Api::DictionariesController < Api::ApiController
	respond_to :json

	def index
		result = {
			restaurant_types: RestaurantType.all,
			locations: Location.all
		}
		respond_with result
	end
end