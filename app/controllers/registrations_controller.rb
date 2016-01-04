#
# devise controller for registration
#
class RegistrationsController < Devise::RegistrationsController
  # save referral id and cart across registration process
  def create
    cart_id = session[:cart_id]
    ref_id = session[:ref_id]
    super
    if user_signed_in?
      if current_user.ref_id.nil?
        current_user.update_attribute :ref_id, ref_id
      end
    end
    Cart::find(cart_id).update_attribute :user_id, current_user
    session[:cart_id] = cart_id
  end

  before_filter :configure_permitted_parameters

  protected

  # strong parameters support
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

  # allow account update without specifying your password
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
