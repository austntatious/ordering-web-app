class AddWorkTimeToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :work_time, :string, :default => '', :null => false
  end
end
