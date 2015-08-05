class Admin::CategoriesController < AdminController
  before_action :set_category, only: [ :edit, :destroy, :update ]

  def index
    @categories = Category.includes(:restaurant).search(params[:search]).order(sort_order).page(params[:page]).per(20)
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def destroy
    @category.destroy
    redirect_to admin_locations_path
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  protected

    def sort_column
      Category.column_names.include?(params[:sort]) ? params[:sort] : "categories.id"
    end

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :restaurant_id)
    end
end
