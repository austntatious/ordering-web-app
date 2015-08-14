class AddTotalOrderSumToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :total_order_sum, :decimal, default: 0, precision: 8, scale: 2, null: false
  end
end
