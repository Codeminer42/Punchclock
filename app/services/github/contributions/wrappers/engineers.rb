module Github
  module Contributions
    module Wrappers
      class Engineers
        def find_by_github_user(github_user)
          to_h[github_user]
        end

        def to_query
          engineers.map do |github_user, _user_id|
            "author:#{github_user.strip}"
          end.join(' ')
        end

        def empty?
          engineers.empty?
        end

        private 

        def engineers
          @engineers ||= User
            .engineer
            .active
            .pluck(:github, :id)
        end

        def to_h
          engineers.to_h
        end
      end
    end
  end
end
