module Github
  module Contributions
    module Wrappers
      class PullRequest
        CO_AUTHOR_REGEX = %r{Co-authored-by:\s?([À-ÿ\w\s.,'-]*)\s?<(.*)>}

        def initialize(pull_request:, engineers:, repositories:, client:)
          @pull_request = pull_request
          @engineers = engineers
          @repositories = repositories
          @client = client
        end

        def pull_request_url
          pull_request.html_url
        end

        def repository_name
          @repository_name ||= pull_request.html_url.split("/")[-4..-3].join("/")
        end

        def repository_owner
          @repository_owner ||= pull_request.html_url.split("/")[-4]
        end

        def pull_request_number
          @pull_request_number ||= pull_request.html_url.split("/")[-1]
        end

        def pull_request_commits
          @pull_request_commits ||= client.pull_requests.commits(
            user: repository_owner, repo: repository_name.split("/")[-1], number: pull_request_number)
        end

        def get_co_authors_data_by_commit_messages
          co_authors_data = pull_request_commits.map do |commit|
            commit_message = commit.dig("commit", "message")

            data = nil

            unless !commit_message.match?(CO_AUTHOR_REGEX)
              data = commit_message.scan(CO_AUTHOR_REGEX).flatten
              data.first.strip!
            end

            data
          end.compact
          Set.new(co_authors_data)
        end
        
        def get_co_authors_data_by_committers
          co_authors_data = pull_request_commits.map do |commit|
            login = commit.dig("committer", "login")

            login unless pull_request.user.login == login
          end
          
          Set.new(co_authors_data)
        end
        
        def co_authors_ids_by_messages
          get_co_authors_data_by_commit_messages.map do |co_author_data|
            co_author_id = engineers.find_by_github_user(co_author_data.first)

            if co_author_id.nil? 
              co_author = User.find_by(email: co_author_data.last)
              co_author_id = co_author.present? ? co_author.id : nil
            end

            co_author_id
          end
        end

        def co_authors_ids_by_committers
          get_co_authors_data_by_committers.map do |co_author_login|
            engineers.find_by_github_user(co_author_login)
          end
        end

        def co_authors
          @co_authors ||= co_authors_ids_by_messages.concat(co_authors_ids_by_committers).uniq.compact
        end

        def contributors_ids
          [co_authors, user_id].flatten
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

        def pr_state
          return 'merged' if pull_request.state == 'closed' && pull_request.pull_request.merged_at
          pull_request.state
        end

        private

        attr_reader :pull_request, :engineers, :repositories, :client
      end
    end
  end
end
