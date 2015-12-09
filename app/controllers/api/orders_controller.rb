class Api::OrdersController < Api::ApiController
	before_filter :authenticate_user_from_token!

	api! 'Place the new order'
	param :order, Hash do
		param :address, String, 'Delivery address', required: true
		param :location_id, :number, 'Location ID', required: true
		param :driver_instructions, String, 'Driver instructions', required: false
		param :restaurant_instructions, String, 'Restaurant instructions', required: false
		param :contact_name, String, 'Contact name', required: true
		param :contact_phone, String, 'Contact phone', required: true
		param :money_from_account, String, 'Take money from user account', required: false
		param :credit_card_id, String, 'Use credit card to pay an order', required: true
		param :coupon, String, 'Discount coupon value', required: true
		param :products, Array do
			param :id, :number, 'Product ID', required: true
			param :product_options, Array, 'Product options IDs', required: false
			param :count, :number, 'Product quantity', required: true
			param :note, String, 'User comment to this product', required: false
		end
	end
	param :token, String, 'API token'
	def create
		cart = Cart.new
		params[:products].each do |p|
			cart.add_product p[:id], p[:count], p[:note], p[:product_options]
		end
		order = Order.new(order_params)
		order.order_cart cart
		render json: order
	end

	api! 'List user previous orders'
	param :page, :number, 'Page number (paginates per 20)'
	param :token, String, 'API token'
	def index
		@orders = @user.orders.page(params[:page]).per(20)
		render json: @orders
	end

	api! 'User order details'
	param :id, :number, 'Order ID'
	param :token, String, 'API token'
	def show
		@order = @user.orders.find(params[:id])
		render json: @order
	end

	protected
		def order_params
      result = params.require(:order).permit(:address, :driver_instructions, :restaurant_instructions, :contact_name, :contact_phone, :money_from_account)
      result[:user_id] = @user.id
      result
    end
end