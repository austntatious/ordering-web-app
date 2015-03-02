class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, :default => '', :null => false
      t.string :img

      t.timestamps
    end
  end
end
