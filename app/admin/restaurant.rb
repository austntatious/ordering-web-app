ActiveAdmin.register Restaurant do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :img, :phone, :work_time, :recipient_name, :recipient_type,
    :accept_orders_time, :restaurant_type_id, :address,
    :recipient_bank_account_country, :recipient_bank_account_routing_number,
    :stripe_destination, :owner_mail,
    :recipient_bank_account_account_number, :stripe_recipient_id, :location_ids => []
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  form do |f|
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
