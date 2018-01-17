class Client < ActiveRecord::Base
  belongs_to :company

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
