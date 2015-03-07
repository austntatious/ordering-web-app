ActiveAdmin.register Order do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  permit_params :user_id, :address, :driver_instructions, :status, :contact_name, :contact_phone, :restaurant_instructions
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end
  state_action :pay
  state_action :cancel

  form do |f|
    f.inputs '' do
      # f.input :status, :as => :select, :collection => Order::STATUSES
      f.input :user
      f.input :address
      f.input :driver_instructions
    end
    f.actions
  end

  show do |o|
    attributes_table do
      row :id
      row :user
      row :location
      row :address
      row :status
      row :driver_instructions
      row :created_at
      row :products do
        table_for o.line_items do
          column :name do |li|
            li.product.name
          end
          column :restaurant do |li|
            li.product.category.restaurant.name
          end
          column :price do |li|
            number_to_currency li.product.price
          end
          column :quantity do |li|
            li.count
          end
          column :total_price
        end
      end
    end
  end
end
