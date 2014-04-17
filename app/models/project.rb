class Project < ActiveRecord::Base
  belongs_to :company
  has_many :punches
  validates :name, :company_id, presence: true
end
