class CreateApiTokens < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.string :token, default: '', null: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
