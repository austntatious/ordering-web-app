class AddRestaurantToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :restaurant, index: true
    Order.all.each do |o|
      o.restaurant_id = o.get_restaurant
      o.save
    end
  end
end
