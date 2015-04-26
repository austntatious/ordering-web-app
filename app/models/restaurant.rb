class Restaurant < ActiveRecord::Base
  has_and_belongs_to_many :locations, :join_table => :locations_restaurants
  has_many :categories

  validates :name, :img, :presence => true

  mount_uploader :img, RestaurantUploader

  def set_seo_data(hash)
    tt = Setting::get('Title for restaurant page')
    unless tt.blank?
      hash[:title] = self.process_seo_str tt
    end
    dt = Setting::get('Description for restaurant page')
    unless dt.blank?
      hash[:description] = self.process_seo_str dt
    end
    kt = Setting::get('Keywords for restaurant page')
    unless kt.blank?
      hash[:keywords] = self.process_seo_str kt
    end
  end

  def process_seo_str(str)
    str.gsub('%restaurant_name%', self.name).
      gsub('%delivery_fee%', '$' + Setting::get('Delivery fee')).
      gsub('%work_time%', '$' + self.work_time).
      gsub('%locations%', '$' + self.locations.map { |l| l.name }.join(', '))
  end
end
