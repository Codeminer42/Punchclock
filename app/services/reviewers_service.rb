# frozen_string_literal: true

class ReviewersService
  def self.save_review(contribution_id, user)
    contribution = Contribution.find(contribution_id)
    contribution.update(reviewed_by: user, reviewed_at: Time.current)
  end
end
