class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, :default => '', :null => false
      t.references :restaurant, index: true

      t.integer :parent_id, :null => true, :index => true
      t.integer :lft, :null => false, :index => true
      t.integer :rgt, :null => false, :index => true

      # optional fields
      t.integer :depth, :null => false
      t.integer :children_count, :null => false

      t.timestamps
    end
  end
end
