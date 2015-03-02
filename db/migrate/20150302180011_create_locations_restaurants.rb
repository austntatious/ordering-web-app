class CreateLocationsRestaurants < ActiveRecord::Migration
  def change
    create_table :locations_restaurants do |t|
      t.integer :location_id
      t.integer :restaurant_id
    end
  end
end
