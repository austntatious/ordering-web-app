class CreditCard < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  attr_accessor :number, :exp_month, :exp_year, :cvc, :name
  validates :user_id, :presence => true

  before_create :create_stripe_card

  def create_stripe_card
    customer = Stripe::Customer.retrieve(self.user.client_id)
    token = Stripe::Token.create(
      :card => {
        :name => self.name,
        :number => self.number,
        :exp_month => self.exp_month,
        :exp_year => self.exp_year,
        :cvc => self.cvc
      }
    )
    # binding.pry
    customer.sources.create(:card => token['id'])
    # puts token.inspect
    self.stripe_id = token['card']['id']
    self.last4 = self.number.split(//).last(4).join
  end
end
