class SetTotalOrderSumInOrders < ActiveRecord::Migration
  def up
    Order.all.each do |o|
      o.set_total_sum
      o.save
    end
  end

  def down
  end
end
