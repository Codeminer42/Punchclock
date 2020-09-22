# frozen_string_literal: true

module Github
  class SearchContribution
    def initialize
      @github = Github.new oauth_token: ENV['GITHUB_OAUTH_TOKEN']
    end

    attr_reader :github

    def perform
      repositories = ::Repository.pluck(:link)
                                 .map(&method(:split_to_gh_pattern))
                                 .compact
                                 .uniq

      profiles = User.engineer.active.pluck(:github)

      prs = repositories.map do |owner, repo|
        github.pull_requests.list(owner, repo)
      end

      miners_contributions = prs.flat_map do |pr|
        pr.body.select { |body| profiles.include? body.user.login }
      end

      ActiveRecord::Base.transaction do
        miners_contributions.each do |contribution|
          create_contribution(contribution)
        end
      end
    end

    private

    def split_to_gh_pattern(url)
      url.split('/')[-2..-1]
    end

    def create_contribution(contribution)
      profile = contribution.user.login
      link = contribution._links.html.href
      CreateContributionService.new.call(user: profile, link: link)
    end
  end
end
