# frozen_string_literal: true

class UserSkill < ApplicationRecord
  validates_presence_of :user, :skill

  belongs_to :user
  belongs_to :skill
end
