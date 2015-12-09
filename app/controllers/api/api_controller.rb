class Api::ApiController < ApplicationController
	skip_before_filter :verify_authenticity_token
	
	def authenticate_user_from_token!
		@api_token = ApiToken.find_by_token(params[:token])
    @user = @api_token.try(:user)
    if @user.nil?
      render json: { success: false, error: 'Not authorized' }, status: 401
    end
  end
end
