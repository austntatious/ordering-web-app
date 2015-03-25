class CreateUsedCoupons < ActiveRecord::Migration
  def change
    create_table :used_coupons do |t|
      t.references :user, index: true
      t.references :coupon, index: true

      t.timestamps
    end
  end
end
