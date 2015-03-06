class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  has_many :line_items, :dependent => :destroy

  def add_product(product_id, count)
    li = line_items.where(:product_id => product_id).first
    if li.nil?
      LineItem.create(:cart_id => self.id, :product_id => product_id, :count => count.to_i)
    else
      li.update_attribute :count, li.count + count.to_i
    end
  end

  def total_count
    line_items.sum(:count)
  end

  def total_price
    line_items.map { |li| li.total_price }.sum
  end

  def set_location(location_id)
    if (location.nil?) || (line_items.count == 0)
      update_attribute :location_id, location_id
    end
  end

  def force_location(location_id)
    update_attribute :location_id, location_id
  end

  def empty?
    !line_items.any?
  end

  def clear!
    line_items.delete_all
  end
end
