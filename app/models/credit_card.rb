# Stored credit card object
# actually all credit card data are stored on stripe
# app stores just the stripe id
class CreditCard < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  # virtual attributes to accept data from forms
  # this data must never be stored on database, so we're using virtual attributes
  attr_accessor :number, :exp_month, :exp_year, :cvc, :name
  validates :user_id, :presence => true

  before_create :create_stripe_card

  # create credit card record on stripe
  def create_stripe_card
    customer = Stripe::Customer.retrieve(self.user.client_id)
    begin
      token = Stripe::Token.create(
        :card => {
          :name => self.name,
          :number => self.number,
          :exp_month => self.exp_month,
          :exp_year => self.exp_year,
          :cvc => self.cvc
        }
      )
      customer.sources.create(:card => token['id'])
      self.stripe_id = token['card']['id']
      self.last4 = self.number.split(//).last(4).join
    rescue
      self.errors.add(:base, 'Credit card error')
      return false
    end
  end

  def as_json(options)
    {
      id: self.id,
      number: "**** **** **** #{self.last4}"
    }
  end
end
