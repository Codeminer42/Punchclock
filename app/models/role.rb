# frozen_string_literal: true

class Role < ApplicationRecord
  DEFAULT_ROLES = %w[normal evaluator admin super_admin open_source_manager hr].freeze

  NORMAL = 'normal'
  EVALUATOR = 'evaluator'
  ADMIN = 'admin'
  SUPER_ADMIN = 'super_admin'
  OPEN_SOURCE_MANAGER = 'open_source_manager'
  HR = 'hr'

  has_and_belongs_to_many :users

  validates :name, uniqueness: { case_sensitive: false }, presence: true
end
