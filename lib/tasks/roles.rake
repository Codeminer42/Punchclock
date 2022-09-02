namespace :roles do
  desc 'Migrate from single role'
  task migrate_from_single_role: :environment do
    ActiveRecord::Base.transaction do
      User.all.each do |user|
        user.update(roles: [user.role])
      end
    end
  end
end
