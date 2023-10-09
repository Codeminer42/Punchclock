class AlertFillContributionDescriptionJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    contributions = user.contributions.received.without_description

    unless contributions.empty?
      NotificationMailer.notify_fill_contribution_description(
        user: user,
        contributions_total: contributions.length,
        contributions_links: contributions.map { [_1.id, _1.link] }
      ).deliver_later
    end
  end
end
