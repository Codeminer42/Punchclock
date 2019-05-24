# frozen_string_literal: true

class Questionnaire < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :evaluations
  belongs_to :company

  validates_presence_of :title, :kind
  validate :being_used, on: :update

  accepts_nested_attributes_for :questions, allow_destroy: true

  scope :active, -> { where(active: true) }

  enum kind: [
    :english, :performance
  ]

  def being_used
    errors.add(:base, 'cannot be changed. It\'s being used') unless evaluations.empty? || active_changed?
  end

  def toggle_active
    update(active: !active)
  end
end
