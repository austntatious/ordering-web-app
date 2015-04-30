class SessionsController < Devise::SessionsController
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
end
