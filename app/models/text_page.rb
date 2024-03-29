# arbitrary text page model
class TextPage < ActiveRecord::Base
  validates :content, :url, :presence => true
  validates_uniqueness_of :url

  scope :search, -> (q) { q.blank? ? where('1 = 1') : where('url iLIKE ? OR content iLIKE ?', "%#{q}%", "%#{q}%")  }
end
