# frozen_string_literal: true

class Project < ApplicationRecord
  extend Enumerize

  include ::Filters::ProjectsFilter

  has_many :punches
  has_many :allocations, dependent: :destroy

  enumerize :market, in: %i[internal international]

  validates :name,
            presence: true,
            uniqueness: true

  validates :market, presence: true

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :by_market, ->(market) { where(market:) if market.present? }
  scope :by_name_like, ->(name) { where("projects.name ILIKE ?", "%#{name}%") if name.present? }
  scope :by_operation, ->(active) { where(active:) if active.present? }

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
