class Admin::UsersController < AdminController
  def index
    @users = User.all.page(params[:page]).per(20)
  end
end
