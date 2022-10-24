namespace :github do
  desc "Sync repository languages"
  task sync_repository_languages: :environment do
    Rails.logger = Logger.new(STDOUT)

    client = Github.new(headers: {"Authorization" => "token #{ENV['GITHUB_OAUTH_TOKEN']}"})

    ActiveRecord::Base.transaction do
      Github::Repositories::Sync
        .new(client: client)
        .call
        .tap { |result| Rails.logger.info("[GH] -- Processed: #{result.size}") }
    end
  end

  desc "Search users contributions and save on database"
  task import_contributions: :environment do
    Rails.logger = Logger.new(STDOUT)

    client = Github.new(headers: {"Authorization" => "token #{ENV['GITHUB_OAUTH_TOKEN']}"})

    ActiveRecord::Base.transaction do
      Github::Contributions::Create
        .new(client: client)
        .call
        .tap { |result| Rails.logger.info("[GH] -- Processed: #{result.size}") }
    end
  end

  desc "Update Pull Requests state on Contributions"
  task update_contributions_pr_state: :environment do
    Rails.logger = Logger.new(STDOUT)

    client = Github.new(headers: {"Authorization" => "token #{ENV['GITHUB_OAUTH_TOKEN']}"})

    ActiveRecord::Base.transaction do
      Github::Contributions::Update
        .new(client: client)
        .call
        .tap { |result| Rails.logger.info("[GH] -- Processed: #{result.size}") }
    end
  end
end
