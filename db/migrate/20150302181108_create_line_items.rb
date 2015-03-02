class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :product, index: true
      t.integer :count, :default => 1, :null => false
      t.references :cart, index: true

      t.timestamps
    end
  end
end
