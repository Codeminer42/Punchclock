# frozen_string_literal: true

class Contribution < ApplicationRecord
  extend Enumerize

  include AASM

  before_update :normalize_description_blank_value

  enumerize :pr_state, in: %i[open closed merged], scope: :shallow, predicates: true
  enumerize :rejected_reason, in: {
    allocated_in_the_project: 0,
    wrong_understanding_of_issue: 1,
    no_sufficient_effort: 2,
    pr_abandoned: 3,
    other_reason: 4
  }
  enumerize :pending, in: %i[mantainer dev other]

  belongs_to :repository
  belongs_to :reviewed_by, class_name: "User", foreign_key: "reviewer_id", optional: true

  has_and_belongs_to_many :users

  aasm column: 'state' do
    state :received, initial: true
    state :approved
    state :refused

    event :approve do
      transitions from: %i[received], to: :approved, after: proc { |reviewer_id|
        ContributionsApprovalService.call(self, reviewer_id:)
      }
    end

    event :refuse do
      transitions from: %i[received], to: :refused, after: proc { |*args| update_rejected_reason(*args) }
    end
  end

  def to_s
    "#{id} - #{users.first}"
  end

  def update_rejected_reason(rejected_reason = "other_reason", reviewer_id)
    update(rejected_reason:, reviewer_id:, reviewed_at: Time.current)
  end

  validates :link, uniqueness: true
  validates :link, :state, presence: true
  validates_presence_of :rejected_reason, if: :refused?
  validates_absence_of :rejected_reason, unless: :refused?

  scope :this_week, lambda {
    where("contributions.created_at >= :start_date", start_date: Date.current.beginning_of_week)
  }

  scope :last_week, lambda {
    where("contributions.created_at >= :start_date AND contributions.created_at <= :end_date",
          start_date: 1.week.ago.beginning_of_week,
          end_date: 1.week.ago.end_of_week)
  }
  scope :active_engineers, -> { joins(:users).merge(User.engineer.active).distinct }
  scope :valid_pull_requests, -> { where.not(state: :refused) }
  scope :without_pr_state, ->(state) { where.not(pr_state: state) }
  scope :tracking, -> { where(tracking: true) }
  scope :without_description, -> { where(description: nil) }
  scope :by_user, lambda { |user_id|
                    if user_id.present?
                      joins(:contributions_users).joins(:users).where('users.id = ?', user_id).distinct
                    end
                  }
  scope :by_state, ->(state) { where(state:) if state.present? }
  scope :by_reviewed_at_from, ->(date) { where('reviewed_at >= ?', date) if date.present? }
  scope :by_reviewed_at_until, ->(date) { where('reviewed_at <= ?', date) if date.present? }
  scope :by_created_at_from, ->(date) { where('created_at >= ?', date) if date.present? }
  scope :by_created_at_until, ->(date) { where('created_at <= ?', date) if date.present? }

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at description id id_value link notes pending pr_state
      rejected_reason repository_id reviewed_at reviewer_id state tracking
      updated_at user_id
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[repository reviewed_by users]
  end

  private

  def normalize_description_blank_value
    self[:description] = description.presence
  end
end
