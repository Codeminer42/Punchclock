class Contribution < ApplicationRecord

  belongs_to :user
  belongs_to :office

  aasm column: 'state' do
    state :received, initial: true
    state :approved
    state :refused
    state :contested
    state :closed

    event :approve do
      transitions from: [:received, :contested], to: :approved
    end
    event :reject do
      transitions from: [:received, :contested], to: :rejected
    end
    event :close do
      transitions from: [:approved], to: :closed
    end
    event :contest do
      transitions from: [:refused], to: :contested
    end
  end

  validates :user, uniqueness: { scope: :link }
end
