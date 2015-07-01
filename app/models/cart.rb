class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  belongs_to :coupon
  has_many :line_items, :dependent => :destroy

  def add_product(product_id, count, options = nil)
    product = Product.find(product_id)
    if product.get_restaurant != self.get_restaurant
      self.clear!
    end
    unless options.nil?
      if options.count > product.toppings_limit * count.to_i
        options = options.slice(0, product.toppings_limit)
      end
    end
    li = line_items.where(:product_id => product_id).first
    if li.nil?
      LineItem.create(:cart_id => self.id, :product_id => product_id, :count => count.to_i, :product_option_ids => options)
    else
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
          LineItem.create(:cart_id => self.id, :product_id => product_id, :count => count.to_i)
        end
      end
    end
  end

  def get_restaurant
    line_items.first.try(:product).try(:get_restaurant)
  end

  def total_count
    line_items.sum(:count)
  end

  def tax_price
    (products_price * Order.get_tax_amount).round(2)
  end

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

  def coupon_applied?
    value = false
    unless self.coupon.nil?
      result = coupon.apply(self)
      value = result[:success]
    end
    value
  end

  def products_price
    line_items.map { |li| li.total_price }.sum
  end

  def total_price
    # binding.pry
    self.products_price + self.tax_price + Order.get_delivery_fee(self.user)
  end

  def set_location(location_id)
    if (location.nil?) || (line_items.count == 0)
      update_attribute :location_id, location_id
    end
  end

  def force_location(location_id)
    update_attribute :location_id, location_id
  end

  def empty?
    !line_items.any?
  end

  def clear!
    line_items.delete_all
  end

  def remove_coupon!
    self.coupon = nil
    save
  end
end
