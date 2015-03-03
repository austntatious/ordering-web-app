class Order < ActiveRecord::Base
  belongs_to :user
  has_many :line_items

  validates :address, :presence => true

  def total_price
    line_items.map { |li| li.total_price }.sum
  end
end
