require 'ga_api'

class Admin::DashboardController < AdminController
  def index
    @stats = Order.get_stats
  end

  def ga
    respond_to do |format|
      format.json { render :json => GaApi.get_week_summary }
    end
  end

  def add_ctl_breadcrumb
    add_breadcrumb 'Dashboard', admin_dashboard_path
  end
end
