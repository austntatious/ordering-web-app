# model to save coupons used by users
class UsedCoupon < ActiveRecord::Base
  belongs_to :user
  belongs_to :coupon
end
