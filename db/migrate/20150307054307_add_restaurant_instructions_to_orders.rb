class AddRestaurantInstructionsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :restaurant_instructions, :text
    add_column :orders, :contact_name, :string, :default => '', :null => false
    add_column :orders, :contact_phone, :string, :default => '', :null => false
  end
end
