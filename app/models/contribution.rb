# frozen_string_literal: true

class Contribution < ApplicationRecord
  extend Enumerize

  include AASM

  enumerize :pr_state, :in => [:open, :closed, :merged], scope: :shallow, predicates: true

  belongs_to :user
  belongs_to :repository
  belongs_to :reviewed_by, class_name: "User", foreign_key: "reviewer_id", optional: true

  aasm column: 'state' do
    state :received, initial: true
    state :approved
    state :refused

    after_all_transitions Proc.new {|*args| update_reviewer(*args) }

    event :approve do
      transitions from: %i[received], to: :approved
    end

    event :refuse do
      transitions from: %i[received], to: :refused
    end
  end

  def to_s
    "#{id} - #{user}"
  end

  def update_reviewer(reviewer_id)
    self.update(reviewer_id: reviewer_id, reviewed_at: Time.current)
  end

  validates :link, uniqueness: true
  validates :link, :state, presence: true

  scope :this_week, -> { where("contributions.created_at >= :start_date", { :start_date => Date.today.beginning_of_week }) }
  scope :last_week, -> { where("contributions.created_at >= :start_date AND contributions.created_at <= :end_date", { :start_date => 1.week.ago.beginning_of_week, :end_date => 1.week.ago.end_of_week }) }
  scope :active_engineers, -> { joins(:user).merge(User.engineer.active) }
end
