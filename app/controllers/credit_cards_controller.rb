#
# Standard resource controller
# to store credit cards data
#
class CreditCardsController < ApplicationController
  respond_to :js, :html

  def create
    @credit_card = CreditCard.new(credit_card_params)
    @credit_card.save
  end

  private

    def credit_card_params
      result = params.require(:credit_card).permit(:number, :exp_month, :exp_year, :cvc, :name)
      result[:user_id] = current_user.id
      result[:number] = result[:number].to_s.gsub(' ', '') # format cc number to remove spaces
      result
    end
end

