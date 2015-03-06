class LineItemsController < InheritedResources::Base
  def increase
    @line_item = @current_cart.line_items.where(:id => params[:line_item_id]).first
    if @line_item.count > 0
      @line_item.update_attribute :count, @line_item.count + 1
    end
  end

  def decrease
    @line_item = @current_cart.line_items.where(:id => params[:line_item_id]).first
    if @line_item.count > 0
      @line_item.update_attribute :count, @line_item.count - 1
    else
      @line_item.destroy
    end
  end

  def create
    if params[:clear_cart] == '1'
      @current_cart.clear!
      @current_cart.force_location session[:current_location]
    end
    @current_cart.add_product line_item_params[:product_id], line_item_params[:count]
    for i in 0..2
      unless params["related_product_#{i}"].nil?
        @current_cart.add_product params["related_product_#{i}"], params["related_product_count_#{i}"] || 1
      end
    end
  end

  def new
    @line_item = LineItem.new(:product_id => params[:product_id])
  end

  def destroy
    @line_item = @current_cart.line_items.where(:id => params[:id]).first
    unless @line_item.nil?
      @line_item.destroy
    end
  end

  private

    def line_item_params
      result = params.require(:line_item).permit(:product_id, :count)
      result[:cart_id] = @current_cart.id
      result
    end
end

