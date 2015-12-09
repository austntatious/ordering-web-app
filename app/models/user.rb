class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook, :stripe_connect]

  has_many :orders
  has_many :carts
  has_many :account_transactions
  has_many :invites, :dependent => :destroy
  has_many :used_coupons, :dependent => :destroy
  has_many :credit_cards, :dependent => :destroy

  # validates :name, :presence => true
  # validates_uniqueness_of :phone
  scope :search, -> (q) { q.blank? ? where('1 = 1') : where('email iLIKE ?', "%#{q}%")  }

  after_commit :create_stripe_client, :on => [:create]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email?
      end
    end
  end

  def create_stripe_client
    NewStripeClientWorker.perform_async self.id
  end

  def current_cart
    self.carts.reorder('created_at DESC').first
  end

  def genarate_phone_confirmation_code(phone)
    self.phone = phone
    code = ''
    6.times do
      code = "#{code}#{rand(9)}"
    end
    self.phone_confirmation_code = code
    self.save
    self.send_confirmation_sms
  end

  def send_confirmation_sms
    SmsApi.send_sms "+1#{self.phone}", "Your confirmation code for StreetEats is #{self.phone_confirmation_code}"
  end

  def generate_api_token
    token = nil
    loop do
      token = Devise.friendly_token
      break token unless ApiToken.where(token: token).first
    end
    ApiToken.create({
      token: token,
      user_id: self.id
    })
  end
end
