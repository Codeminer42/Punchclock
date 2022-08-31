namespace :roles do
  desc 'Creates default roles'
  task create_default_roles: :environment do
    ActiveRecord::Base.transaction do
      Role::DEFAULT_ROLES.each do |role|
        Role.find_or_create_by(name: role)
      end
    end
  end

  desc 'Migrate from single role'
  task migrate_from_single_role: :environment do
    ActiveRecord::Base.transaction do
      User.all.each do |user|
        role = Role.find_by!(name: user.role)
        user.roles << role unless user.roles.include? role
      end
    end
  end
end
