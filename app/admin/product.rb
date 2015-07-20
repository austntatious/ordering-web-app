ActiveAdmin.register Product do
  permit_params :name, :toppings_limit, :price, :description, :category_id, :product_options_attributes => [ :id, :name, :price, :_destroy ], :product_ids => []

  collection_action :do_import_csv, method: :post do
    if params[:restaurant_id].blank? || params[:file].blank?
      redirect_to '/admin/products/import_csv', notice: 'All fields are required'
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

    redirect_to collection_path, notice: "CSV imported successfully! Products added: #{added}. Products changed: #{changed}. With errors: #{with_errors}. Categories created: #{new_categories}"
  end

  collection_action :import_csv, method: :get do
    @restaurants = Restaurant.all
  end

  action_item(:only => :index) do
    link_to "Import CSV", '/admin/products/import_csv'
  end

  form do |f|
    f.inputs '' do
      f.input :name
      f.input :price
      f.input :description
      f.input :category
      f.input :toppings_limit
      f.input :products, :as => :check_boxes, :collection => Product.by_restaurant(f.object.get_restaurant)
      f.has_many :product_options do |po|
        po.input :name
        po.input :price
        if !po.object.nil?
          po.input :_destroy, :as => :boolean, :label => 'Delete'
        end
          # po.form_buffers.last
      end
    end
    f.actions
  end
end
