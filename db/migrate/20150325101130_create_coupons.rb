class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code, :default => '', :null => false
      t.decimal :value, :default => 0, :null => false, :scale => 2, :precision => 8
      t.decimal :min_price, :default => 0, :null => false, :scale => 2, :precision => 8
      t.datetime :valid_till

      t.timestamps
    end
  end
end
