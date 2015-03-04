class Location < ActiveRecord::Base
  has_and_belongs_to_many :restaurants, :join_table => :locations_restaurants
  has_many :carts, :dependent => :destroy
  validates :name, :img, :presence => true

  mount_uploader :img, LocationUploader
end
