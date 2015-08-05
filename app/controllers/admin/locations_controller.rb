class Admin::LocationsController < AdminController
  before_action :set_location, only: [ :edit, :destroy, :update ]
  def index
    @locations = Location.page(params[:page]).per(20)
  end

  def edit
  end

  def destroy
    @location.destroy
    redirect_to admin_locations_path
  end

  def update
    if @location.update(location_params)
      redirect_to admin_locations_path
    else
      render :edit
    end
  end

  protected
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:name, :coords, :img)
    end
end
