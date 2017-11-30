# Based on https://gist.github.com/fgrehm/4253885
# which is a fork of https://gist.github.com/njvitto/362873
namespace :notification do
  desc 'Send email to fill punch'
  task fill_punch: :environment do
    AlertFillPunchJob.perform_later
  end

  desc 'Verify and send email to admin if someone register extra hour'
  task verify_extra_hour: :environment do
    SendEmailWithExtraHourJob.perform_later
  end
end
