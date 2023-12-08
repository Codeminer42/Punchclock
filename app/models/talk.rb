# frozen_string_literal: true

class Talk < ApplicationRecord
  belongs_to :user

  validates :event_name, :talk_title, :date, presence: true
  validate :future_date?

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at date event_name id id_value talk_title updated_at user_id
    ]
  end

  private

  def future_date?
    return if date.blank?

    errors.add(:date, :future_date) if date.future?
  end
end
