class ProjectSerializer < ActiveModel::Serializer
  belongs_to :punch
  attributes :name
end
