# location object
class Location < ActiveRecord::Base
  has_and_belongs_to_many :restaurants, :join_table => :locations_restaurants
  has_many :carts, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  validates :name, :img, :presence => true

  mount_uploader :img, LocationUploader

  scope :search, -> (q) { q.blank? ? where('1 = 1') : where('name iLIKE ?', "%#{q}%")  }

  # loads SEO templates and format strings for SEO tags
  def set_seo_data(hash)
    tt = Setting::get('Title for location page')
    unless tt.blank?
      hash[:title] = self.process_seo_str tt
    end
    dt = Setting::get('Description for location page')
    unless dt.blank?
      hash[:description] = self.process_seo_str dt
    end
    kt = Setting::get('Keywords for location page')
    unless kt.blank?
      hash[:keywords] = self.process_seo_str kt
    end
  end

  def process_seo_str(str)
    str.gsub('%location_name%', self.name).
      gsub('%delivery_fee%', '$' + Setting::get('Delivery fee')).
      # gsub('%work_time%', '$' + self.work_time).
      gsub('%restaurants%', '$' + self.restaurants.map { |l| l.name }.join(', '))
  end
end
