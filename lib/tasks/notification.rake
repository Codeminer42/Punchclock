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
