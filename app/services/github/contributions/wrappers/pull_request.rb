module Github
  module Contributions
    module Wrappers
      class PullRequest
        def initialize(pull_request:, engineers:, repositories:)
          @pull_request = pull_request
          @engineers = engineers
          @repositories = repositories
        end

        def pull_request_url
          pull_request.html_url
        end

        def repository_name
          @repository_name ||= pull_request.html_url.split("/")[-4..-3].join("/")
        end

        def user_id
          engineers.find_by_github_user(pull_request.user.login)
        end

        def repository_id
          repositories.find_repository_id_by_name(repository_name)
        end

        def created_at
          pull_request.created_at
        end

        private

        attr_reader :pull_request, :engineers, :repositories
      end
    end
  end
end
