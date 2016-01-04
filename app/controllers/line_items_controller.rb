#
# Resource controller for line items (products in cart)
#
class LineItemsController < ApplicationController
  # increase amount of product in cart (+ button)
  def increase
    @line_item = @current_cart.line_items.where(:id => params[:line_item_id]).first
    if @line_item.count > 0
      @line_item.update_attribute :count, @line_item.count + 1
    end
  end

  # decrease amount of product in cart (- button)
  def decrease
    @line_item = @current_cart.line_items.where(:id => params[:line_item_id]).first
    if @line_item.count > 0
      @line_item.update_attribute :count, @line_item.count - 1
    else
      @line_item.destroy # destroy database record if quantity was decreased to 0
    end
  end

  # add item to cart
  def create
    # clear_cart param can be added if restaurant or location changed for initial
    # this means that we need to clear the cart before add anything to it
    if params[:clear_cart] == '1'
      @current_cart.clear!
      @current_cart.force_location session[:current_location]
    end
    # add item to cart
    @current_cart.add_product line_item_params[:product_id], line_item_params[:count], line_item_params[:note], line_item_params[:product_option_ids]
    # add related products if exists
    for i in 0..2
      unless params["related_product_#{i}"].nil?
        @current_cart.add_product params["related_product_#{i}"], params["related_product_count_#{i}"] || 1
      end
    end
  end

  # used to show "add product to cart" form
  def new
    @product = Product.find(params[:product_id])
    @line_item = LineItem.new(:product_id => @product.id)
  end

  # remove item from cart
  def destroy
    @line_item = @current_cart.line_items.where(:id => params[:id]).first
    unless @line_item.nil?
      @line_item.destroy
    end
  end

  private

    def line_item_params
      result = params.require(:line_item).permit(:product_id, :count, :note, :product_option_ids => [])
      result[:cart_id] = @current_cart.id
      result
    end
end

