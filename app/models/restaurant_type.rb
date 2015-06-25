class RestaurantType < ActiveRecord::Base
  has_many :restaurants
  validates :name, :presence => true
end
