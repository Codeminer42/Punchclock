# frozen_string_literal: true

class Contribution < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :company
  has_many :reviews, dependent: :destroy

  aasm column: 'state' do
    state :received, initial: true
    state :approved
    state :refused

    event :approve do
      transitions from: %i[received], to: :approved
    end

    event :refuse do
      transitions from: %i[received], to: :refused
    end
  end

  validates :link, uniqueness: true
  validates :link, :state, presence: true
end
