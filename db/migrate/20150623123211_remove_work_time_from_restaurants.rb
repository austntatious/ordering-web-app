class RemoveWorkTimeFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :work_time, :string
  end
end
