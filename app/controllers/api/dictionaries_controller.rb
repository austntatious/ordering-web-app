class Api::DictionariesController < Api::ApiController
	respond_to :json

	api! 'Returns entity dictionaries such as locations and restaurant_types'
	def index
		result = {
			restaurant_types: RestaurantType.all,
			locations: Location.all
		}
		respond_with result
	end
end