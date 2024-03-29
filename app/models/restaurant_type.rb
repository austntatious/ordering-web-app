# restaurant type (cousine) model
class RestaurantType < ActiveRecord::Base
  has_many :restaurants
  validates :name, :presence => true

  scope :search, -> (q) { q.blank? ? where('1 = 1') : where('name iLIKE ?', "%#{q}%")  }
end
