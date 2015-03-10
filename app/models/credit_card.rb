class CreditCard < ActiveRecord::Base
  belongs_to :user

  attr_accessor :number, :exp_month, :exp_year, :cvc, :name
  validates :user_id, :presence => true

  before_create :create_stripe_card

  def create_stripe_card
    token = Stripe::Token.create(
      :card => {
        :name => self.name,
        :number => self.number,
        :exp_month => self.exp_month,
        :exp_year => self.exp_year,
        :cvc => self.cvc
      }
    )
    # puts token.inspect
    self.stripe_id = token['card']['id']
    self.last4 = self.number.split(//).last(4).join
  end
end
