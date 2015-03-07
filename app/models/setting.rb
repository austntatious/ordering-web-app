class Setting < ActiveRecord::Base
  validates :name, :value, :presence => true

  validates_uniqueness_of :name

  SETTINGS_KINDS = ['Admin phone', 'Admin email', 'Work from', 'Work to', 'Delivery fee']

  def self.get(nm)
    Setting.find_by_name(nm).try(:value) || ''
  end

  def self.can_get_orders?
    result = true
    begin
      from_time = Setting.get('Work from')
      to_time = Setting.get('Work to')
      if from_time.blank?
        from_time = '11:00'
      end
      if to_time.blank?
        to_time = '02:00'
      end
      parts_from = from_time.split(':')
      hour_from = parts_from[0].to_i
      min_from = parts_from[1].to_i
      parts_to = to_time.split(':')
      hour_to = parts_to[0].to_i
      min_to = parts_to[1].to_i
      time_from = DateTime.now.change :hour => hour_from, :min => min_from
      time_to = DateTime.now.change :hour => hour_to, :min => min_to
      if hour_to < 10
        time_to = time_to + 1.day
      end
      time_now = DateTime.now
      if time_to <= time_now || time_from >= time_now
        result = false
      end
    rescue
    end
    result
  end
end
