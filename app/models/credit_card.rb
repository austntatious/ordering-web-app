class CreditCard < ActiveRecord::Base
  belongs_to :user

  attr_accessor :number, :exp_month, :exp_year, :cvc, :name
  validates :user_id, :presence => true

  after_commit :create_stripe_card, :on => [:create]

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
    puts token.inspect
    self.update_attributes :stripe_id => token['card']['id'], :last4 => self.number.split(//).last(4).join
  end
end
