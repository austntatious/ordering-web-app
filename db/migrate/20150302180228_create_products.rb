class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, :default => '', :null => false
      t.decimal :price, :default => 0, :scale => 2, :precision => 8, :null => false
      t.text :description

      t.timestamps
    end
  end
end
