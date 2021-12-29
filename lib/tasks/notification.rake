namespace :notification do
  desc 'Send email to fill punch on day fifteen'
  task fill_punch: :environment do
    AlertFillPunchJob.perform_later("fifteen")
  end

  desc 'Send email to fill punch in the end of month'
  task fill_punch_month: :environment do
    AlertFillPunchJob.perform_later("end_month")
  end


  desc 'Verify and send email to admin if someone register extra hour'
  task verify_extra_hour: :environment do
    SendEmailWithExtraHourJob.perform_later
  end

  desc 'Verify and send email to users and admin about unregistered punches'
  task unregistered_punches: :environment do
    NotifyUnregisteredPunchesJob.perform_later
  end
end
