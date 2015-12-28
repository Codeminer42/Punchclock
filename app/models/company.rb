class Company < ActiveRecord::Base
  has_many :admin_users
  has_many :projects
  has_many :users
  has_many :punches

  mount_uploader :avatar, CompanyAvatarUploader
end
