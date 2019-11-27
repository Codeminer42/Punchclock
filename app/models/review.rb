class Review < ApplicationRecord
  belongs_to :user
  belongs_to :contribution

  enumerize :state, in: {
    received: 0, approved: 1, refused: 2, contested: 3, closed: 4
    },  scope: :shallow,
        predicates: true

  validates :state, presence: true
end
