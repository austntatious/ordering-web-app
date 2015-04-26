class InviteWorker
  include Sidekiq::Worker

  def perform(invite_id)
    invite = Invite.find_by_id(invite_id)
    unless invite.nil?
      Notifier.invite(invite).deliver
    end
  end
end
