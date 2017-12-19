namespace :notification do

  desc 'Send email to fill punch'
  task fill_punch: :environment do
    AlertFillPunchJob.perform_later
  end
end
