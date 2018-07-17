class Client < ApplicationRecord
  belongs_to :company, optional: true

  validates_presence_of :name

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  def disable!
    update!(active: false)
  end

  def enable!
    update!(active: true)
  end
end
