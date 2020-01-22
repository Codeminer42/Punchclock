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

  scope :this_week, -> { where("created_at >= :start_date", { :start_date => Date.today.beginning_of_week }) }
  scope :last_week, -> { where("created_at >= :start_date AND created_at <= :end_date", { :start_date => 1.week.ago.beginning_of_week, :end_date => 1.week.ago.end_of_week }) }
end
