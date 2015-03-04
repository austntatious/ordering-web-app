class ChangeLatLngInLocations < ActiveRecord::Migration
  def change
    change_column :locations, :latitude, :decimal, :default => 0, :null => false, :precision => 30, :scale => 20
    change_column :locations, :longitude, :decimal, :default => 0, :null => false, :precision => 30, :scale => 20
  end
end
