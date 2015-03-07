class AddPhoneToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :phone, :string, :default => '', :null => false
  end
end
