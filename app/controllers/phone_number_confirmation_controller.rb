class PhoneNumberConfirmationController < InheritedResources::Base
  before_filter :authenticate_user!

  def set_phone
    current_user.genarate_phone_confirmation_code params[:phone]
  end

  def confirmation_form
  end
end

