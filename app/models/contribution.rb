# frozen_string_literal: true

class Contribution < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :office
  has_many :reviews

  aasm column: 'state' do
    state :received, initial: true
    state :approved
    state :refused
    state :contested
    state :closed

    event :approve do
      transitions from: %i[received contested], to: :approved
    end

    event :refuse do
      transitions from: %i[received contested], to: :refused
    end

    event :close do
      transitions from: [:approved], to: :closed
    end

    event :contest do
      transitions from: [:refused], to: :contested
    end
  end

  validates :user, uniqueness: { scope: :link }
  validates :link, :state, presence: true
end
