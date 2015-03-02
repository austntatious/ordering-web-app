class Restaurant < ActiveRecord::Base
  has_and_belongs_to_many :locations, :join_table => :locations_restaurants
  has_many :categories

  validates :name, :img, :presence => true

  mount_uploader :img, RestaurantUploader
end
