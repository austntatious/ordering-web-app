class AddMoneyFromAccountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :money_from_account, :decimal, :default => 0, :null => false
  end
end
