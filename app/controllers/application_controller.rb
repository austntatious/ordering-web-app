class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_current_cart

  def create_cart
    cart = Cart.create()
    session[:cart_id] = cart.id
    @current_cart = cart
  end

  def set_current_cart
    begin
      @current_cart = Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      create_cart
    end
    @current_cart
  end
end
