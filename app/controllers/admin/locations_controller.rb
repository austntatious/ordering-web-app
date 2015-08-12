class Admin::LocationsController < AdminController
  before_action :set_location, only: [ :edit, :destroy, :update ]
  def index
    @locations = Location.search(params[:search]).order(sort_order).page(params[:page]).per(20)
  end

  def new
    @location = Location.new
    add_breadcrumb 'New', new_admin_location_path
  end

  def edit
    add_breadcrumb 'Edit', edit_admin_location_path(@location)
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

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to admin_locations_path
    else
      render :edit
    end
  end

  protected

    def sort_column
      Location.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:name, :coords, :img)
    end

    def add_ctl_breadcrumb
      add_breadcrumb 'Locations', admin_locations_path
    end
end
