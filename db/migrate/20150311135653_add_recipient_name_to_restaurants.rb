class AddRecipientNameToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :recipient_name, :string, :default => '', :null => false
    add_column :restaurants, :recipient_type, :string, :default => '', :null => false
    add_column :restaurants, :recipient_bank_account_country, :string, :default => '', :null => false
    add_column :restaurants, :recipient_bank_account_routing_number, :string, :default => '', :null => false
    add_column :restaurants, :recipient_bank_account_account_number, :string, :default => '', :null => false
    add_column :restaurants, :stripe_recipient_id, :string, :default => '', :null => false
  end
end
