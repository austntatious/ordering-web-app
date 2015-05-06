class Refferal < ActiveRecord::Base
  belongs_to :user
  belongs_to :refferer, :class_name => 'User'
  validates :user_id, :refferer_id, :presence => true

  scope :by_user, ->(uid) { where(:refferer_id => uid) }

  def self.make_bonus(user)
    unless user.ref_id.nil?
      r = Refferal.where(:user_id => user.id, :refferer_id => user.ref_id).first
      if r.nil?
        bonus = Setting::get('Referral bonus')
        if bonus == ''
          bonus = '5'
        end
        ActiveRecord::Base.transaction do
          r = Refferal.create(:user_id => user.id, :refferer_id => user.ref_id)
          r.refferer.update_column :balance, r.refferer.balance + bonus.to_f
          AccountTransaction.create(:kind => AccountTransaction::KIND_REF_BONUS, :user_id => r.refferer_id, :amount => bonus.to_f)
        end
      end
    end
  end
end
