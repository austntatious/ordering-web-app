class AddDriverInstructionsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :driver_instructions, :text
  end
end
