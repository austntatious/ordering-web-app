class Setting < ActiveRecord::Base
  validates :name, :value, :presence => true

  validates_uniqueness_of :name

  SETTINGS_KINDS = ['Admin phone', 'Admin email', 'Work from', 'Work to', 'Delivery fee', 'Emergency message', 'Tax', 'Tweet text']

  def self.get(nm)
    Setting.find_by_name(nm).try(:value) || ''
  end

  def self.can_get_orders?
    result = true
    em = Setting.get('Emergency message')
    unless em.blank?
      return false
    end
    begin
      from_time = Setting.get('Work from')
      to_time = Setting.get('Work to')
      if from_time.blank?
        from_time = '11:00am'
      end
      if to_time.blank?
        to_time = '02:00am'
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
      # if hour_to < 10
      #   time_to = time_to + 1.day
      # end
      time_now = DateTime.now
      # if time_now.hour < 5
      #   time_from = time_from - 1.day
      #   time_to = time_to - 1.day
      # end
      if time_to <= time_now || time_from >= time_now
        result = false
      end
    rescue
    end
    result
  end
end
