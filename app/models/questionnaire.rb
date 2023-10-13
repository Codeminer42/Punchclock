# frozen_string_literal: true

class Questionnaire < ApplicationRecord
  extend Enumerize
  has_many :questions, dependent: :destroy
  has_many :evaluations

  validates_presence_of :title, :kind
  validate :being_used, on: :update

  accepts_nested_attributes_for :questions, allow_destroy: true

  scope :active, -> { where(active: true) }
  scope :by_title_like, ->(title) { where("questionnaires.title ILIKE ?", "%#{title}%") if title.present? }
  scope :by_kind, ->(kind) { where(kind:) if kind.present? }
  scope :by_created_at_from, ->(date) { where("created_at >= ?", date) if date.present? }
  scope :by_created_at_until, ->(date) { where("created_at <= ?", date) if date.present? }

  enumerize :kind,  in: { english: 0, performance: 1 },
                    scope: :shallow,
                    predicates: true

  def being_used
    errors.add(:base, "cannot be changed. It's being used") unless evaluations.empty? || active_changed?
  end

  def toggle_active
    update(active: !active)
  end

  def to_s
    title
  end
end
