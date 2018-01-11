class Client < ActiveRecord::Base
  belongs_to :company

  validates_presence_of :name

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
