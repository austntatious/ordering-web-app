class AddLocationToCart < ActiveRecord::Migration
  def change
    add_reference :carts, :location, index: true
  end
end
