class Project < ActiveRecord::Base
  belongs_to :company
  has_many :punches
end