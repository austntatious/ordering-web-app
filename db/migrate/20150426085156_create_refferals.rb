class CreateRefferals < ActiveRecord::Migration
  def change
    create_table :refferals do |t|
      t.integer :user_id, :null => false
      t.integer :refferer_id, :null => false

      t.timestamps
    end
  end
end
