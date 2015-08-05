class CouponsController < ApplicationController
  respond_to :json

  def index
    result = Coupon.check(params[:code], @current_cart)
    if result[:success]
      session[:coupon_id] = result[:coupon_id]
    end
    respond_to do |format|
      format.json { render :json => result }
    end
  end

  private

    def coupon_params
      params.require(:coupon).permit(:code, :value, :min_price)
    end
end

