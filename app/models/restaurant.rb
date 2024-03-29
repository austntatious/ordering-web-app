# restaurant class
class Restaurant < ActiveRecord::Base
  belongs_to :restaurant_type
  has_and_belongs_to_many :locations, :join_table => :locations_restaurants
  has_many :categories
  has_many :products, through: :categories
  has_many :orders

  # allow to use single form for restaurant, categories and products
  accepts_nested_attributes_for :categories, :allow_destroy => true
  accepts_nested_attributes_for :products, :allow_destroy => true

  scope :search, -> (q) {
    q.blank? ?
      where('1 = 1') :
      joins(:locations, :categories).
        where(
          'restaurants.name iLIKE ? OR categories.name LIKE ? OR locations.name LIKE ?',
          "%#{q}%", "%#{q}%", "%#{q}%"
        )
  }

  validates :name, :img, :accept_orders_time, :presence => true

  mount_uploader :img, RestaurantUploader

  before_save :connect_stripe

  # format and send seo data
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

  # launch stripe connect integration on restaurant creation
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

  def as_json(options)
    {
      id: self.id,
      img: self.img.try(:url),
      thumb: self.img.try(:thumb).try(:url),
      phone: self.phone,
      name: self.name,
      work_time: self.accept_orders_time,
      locations: self.locations.map(&:id),
      restaurant_type: self.restaurant_type_id
    }
  end
end
