# frozen_string_literal: true

class ProfessionalExperience < ApplicationRecord
  belongs_to :user

  validates_presence_of :company, :position, :start_date

  validate :date_format
  validate :greater_than_current_month?, if: -> { valid_date?(start_date) }
  validate :greater_than_end_date?, if: -> { valid_date?(start_date) && valid_date?(end_date) }

  def self.ordered_by_start_date
    all.sort_by { |professional_experience| Date.strptime(professional_experience.start_date, '%m/%Y') }
  end

  scope :by_user, ->(user_id) { where(user_id:) }

  private

  FIELDS_TO_BE_VALIDATED = %i[start_date end_date].freeze

  def greater_than_current_month?
    return if start_date.to_date < Date.today.end_of_month

    errors.add(:start_date,
               I18n.t('activerecord.errors.models.professional_experience.attributes.start_date.greater_than_current_month'))
  end

  def greater_than_end_date?
    return if start_date.to_date < end_date.to_date

    errors.add(:start_date,
               I18n.t('activerecord.errors.models.professional_experience.attributes.start_date.greater_than_end_date'))
  end

  def date_format
    FIELDS_TO_BE_VALIDATED.each do |field|
      next if self[field].blank?

      errors.add(field, 'Invalid date') unless valid_date?(self[field])
    end
  end

  def valid_date?(date)
    return false unless correct_format?(date)

    month, year = date.split('/').map(&:to_i)

    Date.valid_date?(year, month, 1)
  end

  def correct_format?(date)
    %r{(\d{2}/\d{4})}.match?(date)
  end
end
