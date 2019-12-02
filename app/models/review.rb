# frozen_string_literal: true

class Review < ApplicationRecord
  extend Enumerize

  belongs_to :reviewer, class_name: 'User'
  belongs_to :contribution

  enumerize :state, in: { received: 0, approved: 1, refused: 2 }, scope: :shallow, predicates: true

  validates :state, presence: true
end
