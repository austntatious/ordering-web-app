class ChangeDepthOnCategories < ActiveRecord::Migration
  def up
    change_column :categories, :depth, :integer, :null => false, :default => 0
    change_column :categories, :children_count, :integer, :null => false, :default => 0
  end

  def down
    change_column :categories, :depth, :integer, :null => false
    change_column :categories, :children_count, :integer, :null => false
  end
end
