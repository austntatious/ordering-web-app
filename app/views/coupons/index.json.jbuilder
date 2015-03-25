json.array!(@coupons) do |coupon|
  json.extract! coupon, :id, :code, :value, :min_price
  json.url coupon_url(coupon, format: :json)
end
