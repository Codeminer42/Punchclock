namespace :fix_punches do
  desc 'fix punches'
  task fix: :environment do
    company = Company.find(8)
    users = []
    company.includes(users: :punches).users.active.find_in_batches.each do |users|
      users.each do |user|
        users << user

        user.punches.find_in_batches.each do |punches|
          punches.each do |punch|
            if punch.from.zone == "-02"
              punch.update(from: punch.from + 2.hours, to: punch.to + 2.hours)
            elsif punch.from.zone == "-03"
              punch.update(from: punch.from + 3.hours, to: punch.to + 3.hours)
            end
          end
        end
      end
    end
    puts "users fixed"
    p users.map {|u| [u.id, u.name]}
  end
end
