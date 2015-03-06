ActiveAdmin.register Product do
  permit_params :name, :price, :description, :category_id, :product_ids => []

  form do |f|
    f.inputs '' do
      f.input :name
      f.input :price
      f.input :description
      f.input :category
      f.input :products, :as => :check_boxes, :collection => Product.by_restaurant(f.object.get_restaurant)
    end
    f.actions
  end
end
