class AddOrderToAccountTransactions < ActiveRecord::Migration
  def change
    add_reference :account_transactions, :order, index: true
  end
end
