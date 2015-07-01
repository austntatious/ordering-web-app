class AddStripeDestinationToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :stripe_destination, :string, :default => '', :null => false
    add_column :restaurants, :owner_mail, :string, :default => '', :null => false
  end
end
