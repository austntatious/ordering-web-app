#
# Controller for discount coupons checking
#
class CouponsController < ApplicationController
  respond_to :json

  def index
    result = Coupon.check(params[:code], @current_cart)
    if result[:success] # save coupon in session if found
      session[:coupon_id] = result[:coupon_id]
    end
    respond_to do |format|
      format.json { render :json => result }
    end
  end

end

