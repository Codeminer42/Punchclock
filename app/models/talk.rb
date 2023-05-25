# frozen_string_literal: true

class Talk < ApplicationRecord
  belongs_to :user

  validates :event_name, :talk_title, :date, presence: true
  validate :future_date?

  private

  def future_date?
    return if date.blank?

    errors.add(:date, "must be before the today's date") if date.future?
  end
end
