namespace :migrate do
  desc 'migrate contributions user_id column to contributions_user join table'
  task migrate_contributions_users: :environment do
    Rails.logger = Logger.new(STDOUT)
    migrate_count = 0

    ActiveRecord::Base.transaction do 
      Contribution.where.not(user_id: nil).each do |contribution|
        contribution.users << User.find(contribution.user_id)
        contribution.user_id = nil
        contribution.save!
        migrate_count += 1
      end
    end

    Rails.logger.info("Migration complete! -- Contributions migrated: #{migrate_count}")
  end
end
