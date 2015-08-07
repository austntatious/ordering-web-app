class Admin::ProductsController < AdminController
  before_action :set_product, only: [ :edit, :destroy, :update ]
  def index
    @products = Product.search(params[:search]).includes(:category => [ :restaurant ]).order(sort_order).page(params[:page]).per(20)
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  protected

    def sort_column
      Product.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:code, :value, :min_price, :valid_till)
    end
end
