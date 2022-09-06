# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :company
  has_many :punches
  has_many :allocations, dependent: :destroy

  validates :name, 
    presence: true, 
    uniqueness: { 
      scope: :company_id, 
      message: 'Project name already taken' 
    }

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
