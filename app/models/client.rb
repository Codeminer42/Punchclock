# frozen_string_literal: true

class Client < ApplicationRecord
  belongs_to :company, optional: true

  has_many :users, through: :allocations
  has_many :projects

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
