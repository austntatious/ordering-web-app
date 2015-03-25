class CreateProductOptionsLineItems < ActiveRecord::Migration
  def change
    create_table :product_options_line_items do |t|
      t.integer :product_option_id, index: true
      t.integer :line_item_id, index: true
    end
  end
end
