module Filters
  module ProjectsFilter
    extend ActiveSupport::Concern

    included do
      scope :active, -> { where(active: true) }
      scope :inactive, -> { where(active: false) }

      scope :by_market, ->(market) { where(market:) if market.present? }
      scope :by_name_like, ->(name) { where("projects.name ILIKE ?", "%#{name}%") if name.present? }
      scope :by_operation, ->(active) { where(active:) if active.present? }
    end
  end
end
