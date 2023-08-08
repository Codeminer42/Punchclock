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
    assign_reviewer
  end

  private

  attr_accessor :contribution, :reviewer_id

  def assign_reviewer
    contribution.update(reviewer_id:, reviewed_at: Time.current, tracking: true)
  end
end
