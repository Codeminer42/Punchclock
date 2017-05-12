require 'clockwork'

module Clockwork
  handler do |job|
    Rails.logger.info("Running #{job}")
  end

  every(1.day, 'alert.email', if: lambda { |t| t.day == 16 },
    tz: 'America/Sao_Paulo', at: '09:00') do
    AlertFillPunchJob.perform_later
  end

  every(1.day, 'alert.email', if: lambda { |t| t.day == 16 },
    tz: 'America/Sao_Paulo', at: '16:00') do
    AlertSendEmailJob.perform_later
  end

end
