class City < ApplicationRecord
  belongs_to :state

  scope :collection, -> { joins(:state).includes(:state).order('states.name ASC, cities.name ASC') }

  validates :name, presence: :true

  def to_s
    name
  end
end
