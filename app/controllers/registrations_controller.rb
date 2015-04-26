class RegistrationsController < Devise::RegistrationsController
  def create
    cart_id = session[:cart_id]
    ref_id = session[:ref_id]
    super
    if user_signed_in?
      if current_user.ref_id.nil?
        current_user.update_attribute :ref_id, ref_id
      end
    end
    session[:cart_id] = cart_id
  end

  before_filter :configure_permitted_parameters

  protected

  # my custom fields are :name, :heard_how
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :phone,
        :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :phone,
        :email, :password, :password_confirmation, :current_password)
    end
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
