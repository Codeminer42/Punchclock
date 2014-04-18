class Company < ActiveRecord::Base
  has_many :admin_users
  has_many :projects
  has_many :users
  has_many :punches
  has_many :periods

  mount_uploader :avatar, CompanyAvatarUploader
end
