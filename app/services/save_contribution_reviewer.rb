# frozen_string_literal: true

class SaveContributionReviewer
  def self.call(contribution_id, reviewer)
    contribution = Contribution.find_by(id: contribution_id)
    contribution.update(reviewer_id: reviewer.id, reviewed_at: Time.current)
  end
end
