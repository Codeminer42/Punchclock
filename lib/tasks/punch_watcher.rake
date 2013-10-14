namespace :watcher do
  task punches: :environment do
    Company.all.each do |c|
      admins = c.users.where("\"is_admin\" = TRUE")

      #check punches
      c.users.each do |user|
        puts "#{user.name} from #{c.name}"
        unless user.punches.empty?
          deltaTime = ((Time.now - user.punches.order("\"to\" DESC").first.to)/1.day).abs
          if deltaTime > 7
            puts "still inactive after #{deltaTime.round} days."
            #notify admins
            admins.each do |a|
              puts "Notifying #{a.name}"
              a.notifications.create(message: "#{user.name} still inactive after #{deltaTime.round} days", from_user_id: user.id, event_path: "users/#{user.id}")
              NotificationMailer.notify_admin_punches_pending(a, user).deliver
            end
          end
        end
      end
    end
  end
end