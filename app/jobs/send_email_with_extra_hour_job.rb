class SendEmailWithExtraHourJob < ActiveJob::Base
  queue_as :default

  def perform
    ExtraHourNotificationService.call
  end
end
