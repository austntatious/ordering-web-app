class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name, :default => '', :null => false
      t.string :value, :default => '', :null => false

      t.timestamps
    end
  end
end
