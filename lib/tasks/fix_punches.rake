namespace :fix_punches do
  desc 'fix punches'
  task fix: :environment do
    company = Company.find(8)

    company.users.each do |user|
      puts "Fixing user #{user.id} #{user.name}"

      user.punches.each do |punch|
        if punch.from.zone == "-02"
          punch.update(from: punch.from + 2.hours, to: punch.to + 2.hours)
        elsif punch.from.zone == "-03"
          punch.update(from: punch.from + 3.hours, to: punch.to + 3.hours)
        end
      end
    end
  end
end
