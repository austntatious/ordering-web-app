class AccountTransaction < ActiveRecord::Base
  KIND_REF_BONUS = 1
  KIND_ORDER_PAY = 2

  belongs_to :user
  belongs_to :order
  validates :user_id, :amount, :kind, :presence => true

  scope :refferal, -> { where(:kind => AccountTransaction::KIND_REF_BONUS) }
end
