class AddLatitudeToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :latitude, :decimal, :default => 0, :null => false, :precision => 8, :scale => 6
    add_column :locations, :longitude, :decimal, :default => 0, :null => false, :precision => 8, :scale => 6
    add_column :locations, :radius, :decimal, :default => 0, :null => false, :precision => 8, :scale => 6
  end
end
