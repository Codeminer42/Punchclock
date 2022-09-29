class ProjectContactInformation < ApplicationRecord
  belongs_to :project

  validates_presence_of :name, :email, :project_id
  validates_uniqueness_of :email, scope: :project_id
end
