# frozen_string_literal: true

class Skill < ApplicationRecord
  has_and_belongs_to_many :users
  belongs_to :company

  validates :title, 
    presence: true, 
    uniqueness: {
      case_sensitive: false,
      scope: :company_id
    }
end
