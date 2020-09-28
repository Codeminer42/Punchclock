# frozen_string_literal: true

module Github
  class SearchContribution
    Contribution = Struct.new(:profile, :link)

    class << self
      def call(company_id)
        github = Github.new(oauth_token: ENV['GITHUB_OAUTH_TOKEN'])

        profiles = active_engineers_github_profiles

        return [] if profiles.empty?

        repositories_github_format_links(company_id)
          .flat_map { |owner, repo| filter_miners_pull_requests(github, profiles, owner, repo) }
          .map { |item| Contribution.new(item.user.login, item._links.html.href) }
      end

      private

      def repositories_github_format_links(company_id)
        ::Repository.where(company_id: company_id)
                    .pluck(:link)
                    .map { |url| url.split('/')[-2..-1] }
                    .compact
      end

      def active_engineers_github_profiles
        User.engineer.active.pluck(:github)
      end

      def filter_miners_pull_requests(github, profiles, owner, repo)
        github.pull_requests
              .list(owner, repo)
              .select { |pr| profiles.include? pr.user.login }
      end
    end
  end
end
