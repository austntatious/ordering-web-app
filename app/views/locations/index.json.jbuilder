json.array!(@locations) do |location|
  json.extract! location, :id, :name, :img
  json.url location_url(location, format: :json)
end
