class Admin::ProductsController < AdminController
  before_action :set_product, only: [ :edit, :destroy, :update ]
  def index
    @products = Product.search(params[:search]).includes(:category => [ :restaurant ]).order(sort_order).page(params[:page]).per(20)
  end

  def new
    @product = Product.new
    add_breadcrumb 'New', new_admin_product_path
  end

  def edit
    add_breadcrumb 'Edit', edit_admin_product_path(@product)
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

  def import
    @restaurants = Restaurant.all
    add_breadcrumb 'Import', admin_products_import_path
  end

  def do_import
    if params[:restaurant_id].blank? || params[:file].blank?
      redirect_to admin_products_import_path, flash: { error: 'All fields are required' }
      return
    end

    infile = params[:file].read
    n, errs = 0, []
    added = 0
    changed = 0
    new_categories = 0
    with_errors = 0

    CSV.parse(infile, {:col_sep => ';'} ) do |row|
      category = Category.where(:name => row[3], :restaurant_id => params[:restaurant_id]).first
      if category.nil?
        category = Category.create({
          :name => row[3],
          :restaurant_id => params[:restaurant_id]
        })
        new_categories = new_categories + 1
      end
      product = Product.where(:category_id => category.id, :name => row[0]).first
      attrs = {
        :name => row[0],
        :price => row[1],
        :description => row[2],
        :category_id => category.id
      }
      if product.nil?
        product = Product.create(attrs)
        added = added + 1
      else
        product.update_attributes(attrs)
        changed = changed + 1
      end
      if product.errors.any?
        with_errors = with_errors + 1
      else
        if row.length > 4
          i = 4
          while i < row.length
            name = row[i]
            price = nil
            if row.length > i + 1
              price = row[i + 1].to_f
            end
            unless price.nil?
              option_fields = {
                :product_id => product.id,
                :name => name,
                :price => price
              }
              option = ProductOption.where(:product_id => product.id, :name => name).first
              if option.nil?
                ProductOption.create(option_fields)
              else
                option.update_attributes(option_fields)
              end
            end
            i = i + 2
          end
        end
      end
    end

    redirect_to admin_products_path, flash: { notice: "CSV imported successfully! Products added: #{added}. Products changed: #{changed}. With errors: #{with_errors}. Categories created: #{new_categories}" }
  end

  protected

    def sort_column
      Product.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:code, :value, :min_price, :valid_till, product_options_attributes: [:id, :price, :name, :_destroy])
    end

    def add_ctl_breadcrumb
      add_breadcrumb 'Products', admin_products_path
    end
end
