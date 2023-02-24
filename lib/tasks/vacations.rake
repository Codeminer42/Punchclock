namespace :vacations do
  desc "Cancel not approved expired vacations"
  task cancel_expired: :environment do
    Vacation.expired.each do |vacation|
      puts "Canceling #{vacation.user.name}'s expired vacation"
      vacation.status = :denied
      vacation.save(validate: false)
    end
  end
end
