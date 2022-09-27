class State < ApplicationRecord
  has_many :cities, dependent: :destroy

  validates :name, :code, presence: true
end
