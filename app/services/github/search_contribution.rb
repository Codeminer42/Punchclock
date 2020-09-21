module Github
  class SearchContribution
    def initialize
      @github = Github.new oauth_token: GITHUB_OAUTH_TOKEN
    end

    attr_reader :github

    def perform
      repositories = Repository.pluck(:link).map(&method(:split_to_gh_pattern)).uniq
      
      prs = repositories.map do |owner, repo|
        github.pull_requests.list(owner, repo)
      end

      User.engineer.active.pluck(:github).map do |profile|
        prs.map do |pr|
          results = pr.body.select { |k| k.user.login == profile }
          create_contribution(results, profile) if results.present?
        end
      end
    end

    private

    def split_to_gh_pattern(link)
      [link.split('/')[3], link.split('/').last]
    end

    def create_contribution(results, profile)
      results.map do |result|
        link = result._links.html.href
        CreateContributionService.new.call(user: profile, link: link)
      end
    end
  end
end
