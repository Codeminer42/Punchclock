class Company < ActiveRecord::Base
  has_many :admin_users
end
