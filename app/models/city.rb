class City < ApplicationRecord
  belongs_to :state

  validates :name, presence: :true

  def to_s
    name
  end
end
