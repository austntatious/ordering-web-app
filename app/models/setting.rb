class Setting < ActiveRecord::Base
  validates :name, :value, :presence => true

  validates_uniqueness_of :name

  SETTINGS_KINDS = ['Admin phone', 'Admin email', 'Work from', 'Work to']

  def self.get(nm)
    Setting.find_by_name(nm).try(:value) || ''
  end
end
