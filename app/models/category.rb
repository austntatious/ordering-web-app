class Category < ActiveRecord::Base
  acts_as_nested_set

  belongs_to :restaurant
  has_many :products

  accepts_nested_attributes_for :products, :allow_destroy => true

  validates :name, :presence => true
end
