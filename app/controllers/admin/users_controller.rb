class Admin::UsersController < AdminController
  before_action :set_user, only: [ :edit, :destroy, :update, :show ]

  def index
    @users = User.search(params[:search]).order(sort_order).page(params[:page]).per(20)
  end

  def new
    @user = User.new
    add_breadcrumb 'New', new_admin_user_path
  end

  def edit
    add_breadcrumb 'Edit', edit_admin_user_path(@user)
  end

  def show
    add_breadcrumb 'Details', admin_user_path(@user)
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path
  end

  def update
    if @user.update_without_password(user_params)
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def create
    @user = User.new(admin_user_params)
    if @user.save
      redirect_to admin_user_path
    else
      render :edit
    end
  end

  protected

    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      x = params.require(:user).permit(:email, :password, :password_confirmation)
      if x[:password].blank?
        x[:password].delete
        x[:password_confirmation].delete
      end
      x
    end

    def add_ctl_breadcrumb
      add_breadcrumb 'Users', admin_users_path
    end
end
