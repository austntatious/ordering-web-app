class CreateTextPages < ActiveRecord::Migration
  def change
    create_table :text_pages do |t|
      t.text :content, :limit => 42949672
      t.string :url, :default => '', :null => false

      t.timestamps
    end
  end
end
