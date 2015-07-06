ActiveAdmin.register Order do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  permit_params :user_id, :address, :driver_instructions, :status, :contact_name, :contact_phone,
    :restaurant_instructions, :delivery_fee
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
  state_action :complete

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
      row :contact_name
      row :contact_phone
      row :location
      row :address
      row :status
      row :driver_instructions
      row :restaurant
      row :restaurant_instructions
      row :created_at
      row :products do
        table_for o.line_items do
          column :name do |li|
            li.product.name
          end
          column :note
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
      row :coupon_discount
      row :coupon_code
      row :money_from_account
      row :total_price do |o|
        o.total_price
      end
      row :success_transfer
      row :transfer_error_message
    end
  end

  csv do
    column :id
    column :created_at
    column :restaurant_instructions
    column :products_price do |o|
      number_to_currency o.products_price
    end
    column :products do |o|
      o.line_items.map { |li| "#{li.product.name}#{li.get_addons} - $#{li.single_price}x#{li.count} - $#{li.total_price}" }.join(', ')
    end
  end
end
