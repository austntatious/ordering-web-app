# product category model
class Category < ActiveRecord::Base
  acts_as_nested_set # use nested set for possible tree-style categories

  belongs_to :restaurant
  has_many :products

  # allow edit categories together with products in single form
  accepts_nested_attributes_for :products, :allow_destroy => true

  validates :name, :presence => true

  scope :search, -> (q) { q.blank? ? where('1 = 1') : joins(:restaurant).where('categories.name iLIKE ? OR restaurants.name iLIKE ?', "%#{q}%", "%#{q}%")  }

  def as_json(options)
  	{
  		id: self.id,
  		name: self.name
  	}
  end
end
