class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true
      t.string :address, :default => '', :null => false

      t.timestamps
    end
  end
end
