class LineItem < ActiveRecord::Base
  belongs_to :product
  has_and_belongs_to_many :product_options, :join_table => :product_options_line_items
  belongs_to :cart
  belongs_to :order

  def total_price
    res = product.price * count
    if product_options.any?
      res = res + product_options.map { |po| po.price }.sum * count
    end
    res
  end

  def single_price
    product.price + product_options.map { |po| po.price }.sum
  end
end
