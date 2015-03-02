json.array!(@restaurants) do |restaurant|
  json.extract! restaurant, :id, :name, :img
  json.url restaurant_url(restaurant, format: :json)
end
