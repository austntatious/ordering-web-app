#
# Basic admin controller. All other controllers for admin area
# will be inherited from this one
#
class AdminController < ApplicationController
  before_filter :authenticate_admin_user!
  before_filter :set_breadcrumbs
  before_action :add_ctl_breadcrumb

  def set_breadcrumbs
    @breadcrumbs = [
      { name: 'Home', url: '/admin' }
    ]
  end

  def add_breadcrumb(name, url)
    @breadcrumbs << { name: name, url: url }
  end
end

