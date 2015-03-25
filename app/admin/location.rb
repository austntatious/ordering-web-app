ActiveAdmin.register Location do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :img, :coords
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
      f.input :img
      # f.input :latitude
      # f.input :longitude
      # f.input :radius
      f.input :coords, :as => :hidden
      f.inputs "" do
        "<script type=\"text/javascript\" src=\"https://maps.google.com/maps/api/js?v=3&libraries=drawing\"></script>
        <div id=\"place-map-holder\">
          Some kind of content
        </div>".html_safe
      end
    end
    f.actions
  end


end
