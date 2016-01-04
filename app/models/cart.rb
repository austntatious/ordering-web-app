# Shopping cart class
class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  belongs_to :coupon
  has_many :line_items, :dependent => :destroy

  delegate :code, :value, :to => :coupon, :prefix => true

  # add product to cart. quite complex method, but I don't know
  # how to split it in smaller parts
  def add_product(product_id, count, note, options = nil)
    product = Product.find(product_id)
    # clear cart if product restaurant doesn't match cart restaurant
    # this can happen on restaurant change during order placement
    if product.get_restaurant != self.get_restaurant
      self.clear!
    end
    # prepare product options and validate toppings limit
    unless options.nil?
      if options.count > product.toppings_limit * count.to_i
        options = options.slice(0, product.toppings_limit)
      end
    end
    # try to find the same product in cart
    li = line_items.where(:product_id => product_id, :note => note).first
    if li.nil? # product not found in cart
      # create new 'product in cart' record
      LineItem.create(:cart_id => self.id, :product_id => product_id, :count => count.to_i, :product_option_ids => options, :note => note)
    else #product already in cart
      unless options.nil? #we have some product options
        # searching for line item with such product options
        sorted_options = options.sort.join('-')
        found = false
        line_items.where(:product_id => product_id).each do |li|
          if li.product_options.map { |po| po.id }.sort.join('-') == sorted_options
            li.update_attribute :count, li.count + count.to_i
            found = true
          end
        end
        # if line item with such options not found
        unless found
          LineItem.create(:cart_id => self.id, :product_id => product_id, :count => count.to_i, :product_option_ids => options)
        end
      else #we have no product options
        found = false
        line_items.where(:product_id => product_id).each do |li|
          unless li.product_options.any?
            found = true
            li.update_attribute :count, li.count + count.to_i
          end
        end
        unless found
          # product in cart not found, let's create a new one
          LineItem.create(:cart_id => self.id, :product_id => product_id, :count => count.to_i)
        end
      end
    end
  end

  # determine cart restaurant
  def get_restaurant
    line_items.first.try(:product).try(:get_restaurant)
  end

  # total items in cart count
  def total_count
    line_items.sum(:count)
  end

  # calculate taxes
  def tax_price
    (products_price * Order.get_tax_amount).round(2)
  end

  # mark coupon is used by user
  def mark_coupon_used(user)
    if self.user.nil?
      self.user = user
    end
    unless self.coupon.nil?
      unless self.user.nil?
        UsedCoupon.create(:coupon_id => self.coupon_id, :user_id => self.user_id)
      end
    end
  end

  # calculate price with coupon discount
  def total_price_with_coupon
    value = self.total_price
    unless self.coupon.nil?
      result = coupon.apply(self)
      if result[:success]
        value = result[:new_sum]
      end
    end
    value
  end

  # check if coupon was applied to cart
  def coupon_applied?
    value = false
    unless self.coupon.nil?
      result = coupon.apply(self)
      value = result[:success]
    end
    value
  end

  # calculate total products price in cart
  def products_price
    line_items.map { |li| li.total_price }.sum
  end

  # calculate total price with taxes and delivery fee
  def total_price
    # binding.pry
    self.products_price + self.tax_price + Order.get_delivery_fee(self.user)
  end

  # save location info if not yet set
  def set_location(location_id)
    if (location.nil?) || (line_items.count == 0)
      update_attribute :location_id, location_id
    end
  end

  # save location info and overwrite existing
  def force_location(location_id)
    update_attribute :location_id, location_id
  end

  # check if cart is empty
  def empty?
    !line_items.any?
  end

  # clear cart
  def clear!
    line_items.delete_all
  end

  # remove saved coupon from cart
  def remove_coupon!
    self.coupon = nil
    save
  end
end
