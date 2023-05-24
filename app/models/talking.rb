# frozen_string_literal: true

class Talking < ApplicationRecord
  belongs_to :user

  validates :event_name, :talk_title, :date, presence: true
  validate :future_date?

  private

  def future_date?
    return if date.blank?

    if date.after? Date.today.next_day
      errors.add(:date, "must be before the today's date")
    end
  end
end
