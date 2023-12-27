# frozen_string_literal: true

class Skill < ApplicationRecord
  has_many :user_skills
  has_many :users, through: :user_skills

  validates :title,
            presence: true,
            uniqueness: { case_sensitive: false }

  scope :by_title_like, ->(title) { where("skills.title ILIKE ?", "%#{title}%") if title.present? }

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id id_value title updated_at]
  end
end
