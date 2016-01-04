#
# Controller for referral program
#
class ReferralController < ApplicationController
  before_filter :authenticate_user

  # restrict to authorized users only
  def authenticate_user
    unless user_signed_in?
      redirect_to account_path
    end
  end

  # invite friends to be your referrals
  def invite
    emails = params[:email].split(',')
    sent = 0
    emails.each do |email|
      # create an Invite object for each email
      # this will be user for bonuses calculation
      if Invite.where(:user_id => current_user.id, :email => email).first.nil?
        Invite.create({
          :user_id => current_user.id,
          :email => email
        })
        sent = sent + 1
      end
    end
    if sent == 0
      redirect_to referral_path, :notice => "You already sent invitations to these emails"
    else
      redirect_to referral_path, :notice => "You successfully sent #{sent} #{'invitation'.pluralize(sent)}"
    end
  end

  # show referrals list
  def index
  end
end
