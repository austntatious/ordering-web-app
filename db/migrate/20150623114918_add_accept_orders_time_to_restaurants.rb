class AddAcceptOrdersTimeToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :accept_orders_time, :string, :default => '04:30pm-09:00pm', :null => false
  end
end
