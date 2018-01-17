class Project < ApplicationRecord
  belongs_to :company
  belongs_to :client
  has_many :punches
  validates :name, :company_id, presence: true

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def disable!
    update!(active: false)
  end

  def enable!
    update!(active: true)
  end

  def to_s
    name
  end
end
