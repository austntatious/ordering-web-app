class CreateAccountTransactions < ActiveRecord::Migration
  def change
    create_table :account_transactions do |t|
      t.references :user, index: true
      t.decimal :amount, :default => 0, :null => false, :precision => 8, :scale => 2
      t.integer :kind, :null => false

      t.timestamps
    end
  end
end
