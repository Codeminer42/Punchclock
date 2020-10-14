namespace :github do
  desc "Search users contributions and save on database"
  task import_contributions: :environment do
    Rails.logger = Logger.new(STDOUT)

    client = Github.new(oauth_token: ENV['GITHUB_OAUTH_TOKEN'])
    company = Company.find(ENV['COMPANY_ID'])

    ActiveRecord::Base.transaction do
      Github::Contributions::Create
        .new(company: company, client: client)
        .call
        .tap { |result| Rails.logger.info("[GH] -- Processed: #{result.size}") }
    end
  end
end
