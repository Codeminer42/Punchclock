class AlertFillContributionDescriptionJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    contributions = user.contributions.received 

    unless contributions.empty?
      NotificationMailer.notify_fill_contribution_description(user, contributions.length).deliver_later
    end
  end
end
