ActiveAdmin.register Order do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  permit_params :user_id, :address, :driver_instructions, :status
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
end
