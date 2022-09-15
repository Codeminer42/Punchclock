# frozen_string_literal: true

class Skill < ApplicationRecord
  has_and_belongs_to_many :users

  validates :title, 
    presence: true, 
    uniqueness: {
      case_sensitive: false
    }
end
