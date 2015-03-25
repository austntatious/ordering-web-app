class AddCoordsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :coords, :text
  end
end
