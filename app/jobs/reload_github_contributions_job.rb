class ReloadGithubContributionsJob < ApplicationJob
  queue_as :default

  def perform(company)
    client = Github.new(oauth_token: ENV['GITHUB_OAUTH_TOKEN'])

    ActiveRecord::Base.transaction do
      Github::Contributions::Create
        .new(company: company, client: client)
        .call
    end
  end
end
