# frozen_string_literal: true

class Contribution < ApplicationRecord
  extend Enumerize

  include AASM

  enumerize :pr_state, :in => [:open, :closed, :merged], scope: :shallow, predicates: true
  enumerize :rejected_reason, in: {
    allocated_in_the_project: 0,
    wrong_understanding_of_issue: 1,
    no_sufficient_effort: 2,
    pr_abandoned: 3,
    other_reason: 4
  }

  belongs_to :user
  belongs_to :repository
  belongs_to :reviewed_by, class_name: "User", foreign_key: "reviewer_id", optional: true

  aasm column: 'state' do
    state :received, initial: true
    state :approved
    state :refused

    event :approve do
      transitions from: %i[received], to: :approved, after: Proc.new { |*args| update_reviewer(*args) }
    end

    event :refuse do
      transitions from: %i[received], to: :refused, after: Proc.new { |*args| update_rejected_reason(*args) }
    end
  end

  def to_s
    "#{id} - #{user}"
  end

  def update_reviewer(reviewer_id)
    self.update(reviewer_id: reviewer_id, reviewed_at: Time.current)
  end

  def update_rejected_reason(rejected_reason = "other_reason", reviewer_id)
    self.update(rejected_reason: rejected_reason, reviewer_id: reviewer_id, reviewed_at: Time.current )
  end

  validates :link, uniqueness: true
  validates :link, :state, presence: true
  validates_presence_of :rejected_reason, if: :refused?
  validates_absence_of :rejected_reason, unless: :refused?

  scope :this_week, -> do
    where("contributions.created_at >= :start_date", start_date: Date.current.beginning_of_week)
  end

  scope :last_week, -> do
    where("contributions.created_at >= :start_date AND contributions.created_at <= :end_date",
      start_date: 1.week.ago.beginning_of_week,
      end_date: 1.week.ago.end_of_week
    )
  end
  scope :active_engineers, -> { joins(:user).merge(User.engineer.active) }
  scope :valid_pull_requests, -> { where.not(state: :refused) }
  scope :without_pr_state, ->(state) { where.not(pr_state: state) }
end
