class TextPage < ActiveRecord::Base
  validates :content, :url, :presence => true
  validates_uniqueness_of :url
end
