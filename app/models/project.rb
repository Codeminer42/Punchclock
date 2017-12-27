class Project < ActiveRecord::Base
  belongs_to :company
  has_many :punches
  validates :name, :company_id, presence: true

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def to_s
    name
  end
end
