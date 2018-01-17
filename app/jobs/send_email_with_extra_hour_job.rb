class SendEmailWithExtraHourJob < ApplicationJob
  queue_as :default

  def perform
    ExtraHourNotificationService.call
  end
end
