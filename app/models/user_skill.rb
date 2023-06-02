# frozen_string_literal: true

class UserSkill < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :skill

  enumerize :experience_level, in: %i[capable expert], default: :capable

  validates :experience_level, presence: true
end
