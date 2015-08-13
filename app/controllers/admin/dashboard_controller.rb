class Admin::DashboardController < AdminController
  def index
  end

  def add_ctl_breadcrumb
    add_breadcrumb 'Dashboard', admin_dashboard_path
  end
end
