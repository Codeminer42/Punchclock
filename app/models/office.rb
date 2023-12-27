# frozen_string_literal: true

class Office < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :users_without_head, ->(office) { where.not(id: office.head_id) }, class_name: 'User'
  belongs_to :head, class_name: 'User', optional: true

  validates :city, presence: true, uniqueness: true

  scope :active,      -> { where(active: true) }
  scope :inactive,    -> { where(active: false) }

  def to_s
    city
  end

  def calculate_score
    users_overall_scores = users_without_head.not_in_experience.map(&:overall_score).compact

    return if users_overall_scores.empty?

    users_average_score = users_overall_scores.sum / users_overall_scores.size
    update(score: users_average_score.round(2))
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[head users users_without_head]
  end
end
