class CreateProductOptions < ActiveRecord::Migration
  def change
    create_table :product_options do |t|
      t.string :name, :default => '', :null => false
      t.decimal :price, :default => 0, :null => false, :scale => 2, :precision => 8
      t.references :product, index: true

      t.timestamps
    end
  end
end
