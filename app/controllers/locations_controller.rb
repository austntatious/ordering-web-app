class LocationsController < ApplicationController
  def show
    @current_cart.set_location params[:id]
    session[:current_location] = params[:id]
    @location = Location.find params[:id]
  end
end

