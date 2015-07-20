ActiveAdmin.register Restaurant do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :img, :phone, :work_time, :recipient_name, :recipient_type,
    :accept_orders_time, :restaurant_type_id, :address,
    :recipient_bank_account_country, :recipient_bank_account_routing_number,
    :stripe_destination, :owner_mail,
    :recipient_bank_account_account_number, :stripe_recipient_id, :location_ids => [],
    :categories_attributes => [
      :id, :name, :_destroy,
      :products_attributes => [
        :id, :category_id, :name, :price, :description, :toppings_limit, :_destroy,
        :product_options_attributes => [ :id, :name, :price, :_destroy ]
      ]
    ]
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  controller do
    def create
      super
      binding.pry
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs '' do
      f.input :name
      f.input :phone
      f.input :accept_orders_time
      f.input :img
      f.input :locations, :as => :check_boxes
      f.input :restaurant_type
      f.input :address
    end
    f.inputs 'Stripe Connect' do
      f.input :stripe_destination, :input_html => { :disabled => true }
      f.input :owner_mail
    end

    f.inputs 'Categories' do
      f.has_many :categories do |cat|
        cat.input :name
        cat.has_many :products do |pr|
          pr.input :name
          pr.input :price
          pr.input :description
          pr.input :toppings_limit
          pr.has_many :product_options do |po|
            po.input :name
            po.input :price
            if !po.object.nil?
              po.input :_destroy, :as => :boolean, :label => 'Delete option'
            end
          end
        end
        cat.input :_destroy, :as => :boolean, :label => 'Delete category'
      end
    end

    f.inputs 'Payment data' do
      f.input :stripe_recipient_id
      f.input :recipient_name
      f.input :recipient_type, :as => :select, :collection => ['individual', 'corporation']
      f.input :recipient_bank_account_country, :as => :text
      f.input :recipient_bank_account_routing_number
      f.input :recipient_bank_account_account_number
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
      row :phone
      row :recipient_name
      row :recipient_type
      row :recipient_bank_account_country
      row :recipient_bank_account_routing_number
      row :recipient_bank_account_account_number
      row :stripe_recipient_id
      row :accept_orders_time
      row :restaurant_type
      row :address
      row :stripe_destination
      row :owner_mail
      row :stripe_connect_link do |r|
        link_to user_omniauth_authorize_url(:stripe_connect), user_omniauth_authorize_url(:stripe_connect)
      end
    end
  end

end
