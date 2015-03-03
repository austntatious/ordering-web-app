class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :line_items, :dependent => :destroy

  def add_product(product_id, count)
    li = line_items.where(:product_id => product_id).first
    if li.nil?
      LineItem.create(:cart_id => self.id, :product_id => product_id, :count => count)
    else
      li.update_attribute :count, li.count + count
    end
  end

  def total_count
    line_items.sum(:count)
  end
end
