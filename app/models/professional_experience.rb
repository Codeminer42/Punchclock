# frozen_string_literal: true

class ProfessionalExperience < ApplicationRecord
  belongs_to :user

  validates_presence_of :company, :position, :start_date

  validate :valid_date?

  validate :greater_than_current_month?, if: -> { correct_format?(start_date) && date_exists?(start_date) }

  private

  FIELDS_TO_BE_VALIDATE = %i[start_date end_date].freeze

  def greater_than_current_month?
    return if mount_date(start_date) < Date.today.beginning_of_month

    errors.add(:start_date, "Start date can't be ahead of today's date")
  end

  def valid_date?
    FIELDS_TO_BE_VALIDATE.each do |field|
      next if self[field].blank?

      errors.add(field, 'Invalid date') if !correct_format?(self[field]) || !date_exists?(self[field])
    end
  end

  def date_exists?(date)
    splitted_string = date.split('/')

    if Date.valid_date?(splitted_string[1].to_i, splitted_string[0].to_i, 1)
      true
    else
      false
    end
  end

  def correct_format?(date)
    if %r{(\d{2}/\d{4})}.match(date)
      true
    else
      false
    end
  end

  def mount_date(date)
    splitted_string = date.split('/')

    Date.new(splitted_string[1].to_i, splitted_string[0].to_i, 1)
  end
end
