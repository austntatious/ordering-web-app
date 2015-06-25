class AddToppingsLimitToProducts < ActiveRecord::Migration
  def change
    add_column :products, :toppings_limit, :integer, :default => 1, :null => false
  end
end
