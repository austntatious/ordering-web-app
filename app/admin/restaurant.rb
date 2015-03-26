ActiveAdmin.register Restaurant do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :img, :phone, :work_time, :recipient_name, :recipient_type,
    :recipient_bank_account_country, :recipient_bank_account_routing_number,
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
      f.input :work_time
      f.input :img
      f.input :locations, :as => :check_boxes
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


end
