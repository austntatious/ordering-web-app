class LineItemsController < InheritedResources::Base
  def create
    @current_cart.add_product line_item_params[:product_id], line_item_params[:count]
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

