class Category < ActiveRecord::Base
  acts_as_nested_set

  belongs_to :restaurant
  has_many :products

  validates :name, :restaurant_id, :presence => true
end
