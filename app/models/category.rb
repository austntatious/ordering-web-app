class Category < ActiveRecord::Base
  acts_as_nested_set

  belongs_to :restaurant
  has_many :products

  accepts_nested_attributes_for :products, :allow_destroy => true

  validates :name, :presence => true

  scope :search, -> (q) { q.blank? ? where('1 = 1') : joins(:restaurant).where('categories.name LIKE ? OR restaurants.name LIKE ?', "%#{q}%", "%#{q}%")  }
end
