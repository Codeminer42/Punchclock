class Office < ApplicationRecord
  has_many :users
  has_and_belongs_to_many :regional_holidays
  belongs_to :company
  validates :city, presence: true

  def to_s
    city
  end
end
