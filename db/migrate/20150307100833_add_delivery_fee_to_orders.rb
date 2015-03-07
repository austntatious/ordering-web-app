class AddDeliveryFeeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_fee, :decimal, :default => 0, :scale => 2, :precision => 8, :null => false
  end
end
