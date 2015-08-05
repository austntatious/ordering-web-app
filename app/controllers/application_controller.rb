class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_current_cart
  before_filter :set_orders_enabled
  before_filter :set_ref_id
  before_filter :set_seo_params

  helper_method :sort_column, :sort_direction

  def create_cart
    cart = ::Cart.create()
    session[:cart_id] = cart.id
    @current_cart = cart
    if user_signed_in?
      cart.update_attribute :user_id, current_user.id
    end
  end

  def set_current_cart
    begin
      @current_cart = ::Cart.find(session[:cart_id])
      if @current_cart.user.nil?
        if user_signed_in?
          @current_cart.update_attribute :user_id, current_user.id
        end
      end
    rescue ActiveRecord::RecordNotFound
      create_cart
    end
    @current_cart
  end

  def after_sign_in_path_for(resource)
    if resource.kind_of? ::AdminUser
      '/admin'
    else
      if session[:redirect_to_order] = 1
        new_order_path
      else
        request.env['omniauth.origin'] || stored_location_for(resource) || root_path
      end
    end
  end

  def set_orders_enabled
    @hide_footer = false
    @ordering_available = ::Setting.can_get_orders?
  end

  def set_ref_id
    unless params[:ref_id].nil?
      session[:ref_id] = params[:ref_id]
    end
  end

  def set_seo_params
    @seo = {
      :title => ::Setting::get('Title for index page'),
      :keywords => ::Setting::get('Keywords for index page'),
      :description => ::Setting::get('Description for index page')
    }
  end

  protected
    def sort_column
      nil
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sort_order
      "#{sort_column} #{sort_direction}"
    end
end
