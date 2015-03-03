class RegistrationsController < Devise::RegistrationsController
  def create
    cart_id = session[:cart_id]
    super
    session[:cart_id] = cart_id
  end
end
