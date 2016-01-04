#
# simple controller for phone number confirmation
#
class PhoneNumberConfirmationController < ApplicationController
  before_filter :authenticate_user!

  # change user phone, generate confirmation code and send SMS to new number
  def change_phone
    current_user.genarate_phone_confirmation_code params[:phone]
  end

  # validate confirmation code and mark phone as confirmed if code is valid
  def confirm_code
    if current_user.phone_confirmation_code == params[:code]
      current_user.has_confirmed_phone = true
      current_user.save
    end
  end

  # resend confirmation code one time more
  def send_code_again
    current_user.send_confirmation_sms
  end

  # show phone confirmation form
  def confirmation_form
  end
end

