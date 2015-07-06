class AddHasConfirmedPhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_confirmed_phone, :boolean, :default => false, :null => false
    add_column :users, :phone_confirmation_code, :string, :default => '', :null => false
  end
end
