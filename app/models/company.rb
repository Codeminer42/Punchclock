class Company < ApplicationRecord
  has_many :admin_users
  has_many :projects
  has_many :users
  has_many :punches
  has_many :offices
  has_many :clients
  
  validates :name, presence: true

  mount_uploader :avatar, CompanyAvatarUploader

  def to_s
    name
  end
end
