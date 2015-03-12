class ChangeTransferErrorMessageInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :transfer_error_message, :text, :default => nil, :null => true
  end
end
