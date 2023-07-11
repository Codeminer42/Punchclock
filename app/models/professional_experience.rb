class ProfessionalExperience < ApplicationRecord
  belongs_to :user

  validates_presence_of :company, :position, :start_date

  validates_comparison_of :start_date,
    message: :greater_than_current,
    less_than: ->(_) { Date.current },
    allow_nil: true
end
