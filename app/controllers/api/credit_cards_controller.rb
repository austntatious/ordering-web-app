class Api::CreditCardsController < Api::ApiController
	before_filter :authenticate_user_from_token!

	api! 'Add a credit cart to user profile'
	param :token, String, 'API token'
	param :credit_card, Hash do
		param :number, String, 'Credit card number', required: true
		param :exp_month, String, 'Expiration month', required: true
		param :exp_year, String, 'Expiration year', required: true
		param :cvc, String, 'CVC', required: true
		param :name, String, 'Name on card', required: true
	end
	def create
		@credit_card = CreditCard.create(credit_card_params)
    render json: { success: !@credit_card.errors.any?, errors: @credit_card.errors.full_messages, credit_card: @credit_card }
	end

	api! 'Get a list of user saved credit cards'
	param :token, String, 'API token'
	def index
		credit_cards = @user.credit_cards
		render json: credit_cards
	end

	private

    def credit_card_params
      result = params.require(:credit_card).permit(:number, :exp_month, :exp_year, :cvc, :name)
      result[:user_id] = @user.id
      result[:number] = result[:number].to_s.gsub(' ', '')
      result
    end
end