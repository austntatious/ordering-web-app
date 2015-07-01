class Restaurant < ActiveRecord::Base
  belongs_to :restaurant_type
  has_and_belongs_to_many :locations, :join_table => :locations_restaurants
  has_many :categories
  has_many :orders

  validates :name, :img, :accept_orders_time, :presence => true

  mount_uploader :img, RestaurantUploader

  before_save :connect_stripe

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
      gsub('%work_time%', '$' + self.accept_orders_time).
      gsub('%locations%', '$' + self.locations.map { |l| l.name }.join(', '))
  end

  def connect_stripe
    do_connect = false
    unless self.id.nil?
      old_r = Restaurant.find(self.id)
      if old_r.owner_mail.blank? && !self.owner_mail.blank?
        do_connect = true
      end
    else
      unless self.owner_mail.blank?
        do_connect = true
      end
    end
    if do_connect
      StripeConnectWorker.perform_async(self.id)
    end
  end
end
