class AddNoteToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :note, :text
  end
end
