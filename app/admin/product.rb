ActiveAdmin.register Product do
  permit_params :name, :toppings_limit, :price, :description, :category_id, :product_options_attributes => [ :id, :name, :price, :_destroy ], :product_ids => []

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
          po.input :_destroy, :as => :boolean, :label => 'Are you sure?'
        end
          # po.form_buffers.last
      end
    end
    f.actions
  end
end
