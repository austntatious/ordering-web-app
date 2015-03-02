class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name, :default => '', :null => false
      t.string :img

      t.timestamps
    end
  end
end
