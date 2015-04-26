class RefferalController < ApplicationController
  def invite
    emails = params[:email].split(',')
    sent = 0
    emails.each do |email|
      if Invite.where(:user_id => current_user.id, :email => email).first.nil?
        Invite.create({
          :user_id => current_user.id,
          :email => email
        })
        sent = sent + 1
      end
    end
    if sent == 0
      redirect_to refferal_path, :notice => "You already sent invitations to these emails"
    else
      redirect_to refferal_path, :notice => "You successfully sent #{sent} #{'invitation'.pluralize(sent)}"
    end
  end
end
