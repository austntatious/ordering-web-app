class PhoneNumberConfirmationController < ApplicationController
  before_filter :authenticate_user!

  def change_phone
    current_user.genarate_phone_confirmation_code params[:phone]
  end

  def confirm_code
    if current_user.phone_confirmation_code == params[:code]
      current_user.has_confirmed_phone = true
      current_user.save
    end
  end

  def send_code_again
    current_user.send_confirmation_sms
  end

  def confirmation_form
  end
end

