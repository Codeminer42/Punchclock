# frozen_string_literal: true

class ContributionsApprovalService
  def initialize(contribution, reviewer_id:)
    self.contribution = contribution
    self.reviewer_id = reviewer_id
  end

  def self.call(contribution, reviewer_id:)
    new(contribution, reviewer_id:).call
  end

  def call
    update_contribution_review
    set_tracking
  end

  private

  attr_accessor :contribution, :reviewer_id

  def update_contribution_review
    contribution.update_reviewer reviewer_id
  end

  def set_tracking
    contribution.update(tracking: true)
  end
end
