class Order < ActiveRecord::Base
  belongs_to :user
  has_many :line_items

  validates :address, :presence => true
end
