class LocationsController < InheritedResources::Base
  def show
    @current_cart.set_location params[:id]
    session[:current_location] = params[:id]
    super
  end

  private

    def location_params
      params.require(:location).permit(:name, :img)
    end
end

