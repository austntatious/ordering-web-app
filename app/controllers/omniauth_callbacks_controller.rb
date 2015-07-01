class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to account_url
    end
  end

  def stripe_connect
    puts request.env["omniauth.auth"].id
    puts request.env["omniauth.auth"].email

    r_names = []
    Restaurant.where(:owner_mail => request.env["omniauth.auth"]["info"]["email"]).each do |r|
      r.update_column :stripe_destination, request.env["omniauth.auth"]["uid"]
      r_names << r.name
    end
    redirect_to root_url, :notice => "Your Stripe account has been connected with following restaurants: #{r_names.join(', ')}"
  end
end
