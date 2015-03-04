class LineItemsController < InheritedResources::Base
  def create
    if params[:clear_cart] == '1'
      @current_cart.clear!
      @current_cart.force_location session[:current_location]
    end
    @current_cart.add_product line_item_params[:product_id], line_item_params[:count].to_i
  end

  def new
    @line_item = LineItem.new(:product_id => params[:product_id])
  end

  private

    def line_item_params
      result = params.require(:line_item).permit(:product_id, :count)
      result[:cart_id] = @current_cart.id
      result
    end
end

