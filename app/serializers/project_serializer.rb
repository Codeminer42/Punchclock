class ProjectSerializer < ActiveModel::Serializer
  belongs_to :punch
  attributes :id, :name
end
