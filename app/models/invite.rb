# invitation object (store user invitations)
# used for referral program
class Invite < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :email, :presence => true

  after_commit :send_email, :on => [:create]

  def send_email
    InviteWorker.perform_async self.id
  end
end
