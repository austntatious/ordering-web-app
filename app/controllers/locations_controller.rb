#
# standard resource controller
#
class LocationsController < ApplicationController
  def show
    @current_cart.set_location params[:id]
    session[:current_location] = params[:id]
    # save current location in session
    # to show restaurants from saved location only
    @location = Location.find params[:id]
  end
end

