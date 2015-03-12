class AddSuccessTransferToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :success_transfer, :boolean, :default => false, :null => false
    add_column :orders, :transfer_error_message, :string, :default => '', :null => false
  end
end
