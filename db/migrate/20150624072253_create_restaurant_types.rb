class CreateRestaurantTypes < ActiveRecord::Migration
  def change
    create_table :restaurant_types do |t|
      t.string :name, :default => '', :null => false

      t.timestamps
    end
  end
end
