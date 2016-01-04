# 'product in cart' object
class LineItem < ActiveRecord::Base
  belongs_to :product
  has_and_belongs_to_many :product_options, :join_table => :product_options_line_items
  belongs_to :cart
  belongs_to :order

  # total price (with addons and quantity)
  def total_price
    res = product.price * count
    if product_options.any?
      res = res + product_options.map { |po| po.price }.sum * count
    end
    res
  end

  # returns selected addons names
  def get_addons
    res = product_options.map { |po| po.name }.join(', ')
    unless res.blank?
      res = "(#{res})"
    end
    res
  end

  # price for single item (product + addons)
  def single_price
    product.price + product_options.map { |po| po.price }.sum
  end

  def as_json()
    {
      product_id: self.product_id,
      product_name: self.product.name,
      count: self.count,
      note: self.note,
      product_options: self.product_options
    }
  end
end
