class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :stripe_id, :default => '', :null => false
      t.string :last4, :default => '', :null => false
      t.references :user, index: true

      t.timestamps
    end
  end
end
