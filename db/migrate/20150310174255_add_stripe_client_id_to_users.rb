class AddStripeClientIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :client_id, :string, :default => '', :null => false
  end
end
