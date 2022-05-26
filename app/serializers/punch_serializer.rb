class PunchSerializer < ActiveModel::Serializer
  attributes :created_at, :from, :to, :delta_as_hour, :extra_hour
  has_one :project
end
