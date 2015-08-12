class Admin::SettingsController < AdminController
  def index
    @settings = Setting.all
    add_breadcrumb 'Settings', admin_settings_path
  end

  def save
    params[:settings].each_pair do |key, value|
      setting = Setting.find_by_name(key)
      if setting.nil?
        setting = Setting.new(name: key)
      end
      setting.value = value
      setting.save
    end
    redirect_to admin_settings_path
  end

  def seo
    @settings = Setting.all
    add_breadcrumb 'SEO', admin_seo_path
  end

  def save_seo
    params[:settings].each_pair do |key, value|
      setting = Setting.find_by_name(key)
      if setting.nil?
        setting = Setting.new(name: key)
      end
      setting.value = value
      setting.save
    end
    redirect_to admin_seo_path
  end

  def add_ctl_breadcrumb
  end
end
