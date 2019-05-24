# frozen_string_literal: true

class Office < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_and_belongs_to_many :regional_holidays
  belongs_to :company
  belongs_to :head, class_name: 'User', optional: true

  validates :city, presence: true, uniqueness: { scope: :company_id }

  def to_s
    city
  end

  def calculate_score
    users_overall_scores = users.map(&:overall_score)

    return if users_overall_scores.include?(nil) || users_overall_scores.empty?
    users_average_score = users_overall_scores.sum / users.count
    update(score: users_average_score)
  end
end
