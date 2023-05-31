# frozen_string_literal: true

class Skill < ApplicationRecord
  has_many :user_skills
  has_many :users, through: :user_skills

  validates :title,
            presence: true,
            uniqueness: { case_sensitive: false }
end
