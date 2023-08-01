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
