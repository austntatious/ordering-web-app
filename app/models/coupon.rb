# discount coupon class
class Coupon < ActiveRecord::Base
  validates :code, :value, :presence => true
  validates_uniqueness_of :code
  has_many :carts
  has_many :used_coupons

  scope :search, -> (q) { q.blank? ? where('1 = 1') : where('code iLIKE ?', "%#{q}%")  }

  # end date validation
  def expired?
    result = false
    unless self.valid_till.nil?
      result = (self.valid_till <= DateTime.now)
    end
    result
  end

  # validate coupon and apply it to cart if possible
  def apply(cart)
    coupon = self
    result = {
      :success => true,
      :msg => 'Coupon is applied'
    }
    unless coupon.nil? #check expiration
      if coupon.expired?
        result[:success] = false
        result[:msg] = "Coupon is expired"
      end
      if result[:success]
        if coupon.min_price > 0 # check coupon min price
          if coupon.min_price > cart.total_price
            result[:success] = false
            result[:msg] = "Your order sum is smaller than coupon minimal sum"
          end
        end
      end
      unless cart.user.nil? # check if coupon was already used
        if UsedCoupon.where(:user_id => cart.user_id, :coupon_id => coupon.id).any?
          result[:success] = false
          result[:msg] = "You have already used this coupon"
        end
      end
      if result[:success] # calculate discount if coupon works
        result[:new_sum_display] = ActionController::Base.helpers.number_to_currency(cart.total_price - coupon.value)
        result[:new_sum] = cart.total_price - coupon.value
        unless cart.coupon_id == coupon.id
          cart.update_attribute :coupon_id, coupon.id
        end
      end
    else
      result[:success] = false
      result[:msg] = "Coupon not found"
    end
    result
  end

  # apply coupon to cart
  def self.check(code, cart)
    coupon = Coupon.find_by_code(code)
    coupon.apply cart
  end
end
