class Admin::AdminUsersController < AdminController
  before_action :set_admin_user, only: [ :edit, :destroy, :update ]

  def index
    @admin_users = AdminUser.search(params[:search]).order(sort_order).page(params[:page]).per(20)
  end

  def new
    @admin_user = AdminUser.new
  end

  def edit
  end

  def destroy
    @admin_user.destroy
    redirect_to admin_admin_users_path
  end

  def update
    if @admin_user.update_without_password(admin_user_params)
      redirect_to admin_admin_users_path
    else
      render :edit
    end
  end

  def create
    @admin_user = AdminUser.new(admin_user_params)
    if @admin_user.save
      redirect_to admin_admin_users_path
    else
      render :edit
    end
  end

  protected

    def sort_column
      AdminUser.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def set_admin_user
      @admin_user = AdminUser.find(params[:id])
    end

    def admin_user_params
      x = params.require(:admin_user).permit(:email, :password, :password_confirmation)
      if x[:password].blank?
        x[:password].delete
        x[:password_confirmation].delete
      end
      x
    end
end
