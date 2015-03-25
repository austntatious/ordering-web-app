class AddCouponDiscountToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :coupon_discount, :decimal, :default => 0, :null => false
    add_column :orders, :coupon_code, :string, :default => '', :null => false
  end
end
