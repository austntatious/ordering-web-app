class Api::UsersController < Api::ApiController
	respond_to :json
	before_filter :authenticate_user_from_token!, except: [:login]

	api! 'Login with user email and password, obtain an access token'
	param :email, String, 'User email', required: true
	param :password, String, 'User password', required: true
	formats ['json']
	def login
		user = User.find_by_email params[:email]
		result = {
    	success: false,
    	error: 'Invalid username or password'
    }
    unless user.nil?
    	result[:success] = user.valid_password? params[:password]
    end
    if result[:success]
    	result[:token] = user.generate_api_token.token
    	result.delete :error
    end
    render json: result
	end

	api! 'Logout and destroy API token'
	param :token, String, 'API token', required: true
	formats ['json']
	def logout
		unless @api_token.nil?
			@api_token.destroy
		end
		render json: {}
	end
end