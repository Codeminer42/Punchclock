require 'clockwork'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'alert.email', if: lambda { |t| t.day == 16 },
    tz: 'America/Sao_Paulo', at: '00:00') do
    AlertFillPunchJob.perform_now
  end
end
