module Github
  module Contributions
    module Wrappers
      class Engineers
        def find_by_github_user(github_user)
          engineers.find_by(github: github_user)
        end

        def find_by_email(email)
          engineers.find_by(email:)
        end

        def to_query
          engineers.map do |engineer|
            "author:#{engineer.github.strip}"
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
        end
      end
    end
  end
end
