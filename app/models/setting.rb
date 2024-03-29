# settings model
class Setting < ActiveRecord::Base
  validates :name, :value, :presence => true

  validates_uniqueness_of :name

  # settings groups
  SETTINGS_KINDS = [
    'Admin phone', 'Admin email', 'Work from', 'Work to', 'Delivery fee', 'Emergency message', 'Tax', 'Tweet text',
    'Referral bonus', 'Title for index page', 'Keywords for index page', 'Description for index page',
    'Title for restaurant page', 'Keywords for restaurant page', 'Description for restaurant page',
    'Title for location page', 'Keywords for location page', 'Description for location page',
    'Facebook invitation text', 'Twitter invitation text',
    'Order arrive since', 'Order arrive before', 'Facebook promotional image path',
    'Order sum limit before 2x delivery', 'Application fee', 'Enable phones confirmation'
  ]

  NEW_SETTINGS_KINDS = {
    'Common' => [ 'Admin phone', 'Admin email', 'Work from', 'Work to', 'Order arrive since', 'Order arrive before' ],
    'Application' => [ 'Tax', 'Order sum before 2x delivery', 'Application fee', 'Enable phones confirmation' ],
    'Refferal' => [ 'Refferal bonus' ]
  }

  SEO_SETTINGS = {
    'SEO' => [ 'Title for index page', 'Keywords for index page', 'Description for index page',
      'Title for restaurant page' , 'Keywords for restaurant page', 'Description for restaurant page',
      'Title for location page', 'Keywords for location page', 'Description for location page'],
    'Social' => [ 'Facebook invitation text', 'Twitter invitation text', 'Facebook promotional image path', 'Tweet text' ]
  }

  # get setting as float
  def self.get_float(nm)
    val = Setting.get(nm)
    if val == ''
      val = 0
    else
      val = val.to_f
    end
    val
  end

  # get setting 'as is'
  def self.get(nm)
    Setting.find_by_name(nm).try(:value) || ''
  end

  # validate if we can accept order now
  # according to 'work from' and 'work to' settings
  def self.can_get_orders?(restaurant = nil)
    result = true
    em = Setting.get('Emergency message')
    unless em.blank?
      return false
    end
    begin
      unless restaurant.nil?
        from_time = Setting.get('Work from')
        to_time = Setting.get('Work to')
      else
        tm = restaurant.accept_orders_time.split('-')
        from_time = tm[0]
        to_time = tm[1]
      end
      if from_time.blank? || to_time.blank?
        return true
      end
      parts_from = from_time.gsub('am', '').gsub('pm', '').split(':')
      hour_from = parts_from[0].to_i
      min_from = parts_from[1].to_i
      if from_time.end_with? "pm"
        hour_from = hour_from + 12
      end
      parts_to = to_time.gsub('am', '').gsub('pm', '').split(':')
      hour_to = parts_to[0].to_i
      min_to = parts_to[1].to_i
      if to_time.end_with? "pm"
        hour_to = hour_to + 12
      end
      time_from = DateTime.now.change :hour => hour_from, :min => min_from
      time_to = DateTime.now.change :hour => hour_to, :min => min_to
      time_now = DateTime.now
      if time_to <= time_now || time_from >= time_now
        result = false
      end
    rescue
    end
    result
  end
end
