class AddRestaurantTypeToRestaurants < ActiveRecord::Migration
  def change
    add_reference :restaurants, :restaurant_type, index: true
  end
end
