class ApiToken < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :token
end
