class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :email, :default => '', :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
  end
end
