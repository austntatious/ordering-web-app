class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :search, -> (q) { q.blank? ? where('1 = 1') : where('email iLIKE ?', "%#{q}%")  }
end
