class AddAddressToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :address, :string, :default => '', :null => false
  end
end
