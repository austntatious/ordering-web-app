class CreateTextPages < ActiveRecord::Migration
  def change
    create_table :text_pages do |t|
      t.text :content, :limit => 4294967295
      t.string :url, :default => '', :null => false

      t.timestamps
    end
  end
end
