module Github
  module Contributions
    module Wrappers
      class Repositories
        def initialize(company:)
          @company = company
        end

        def find_repository_id_by_name(repository_name)
          to_h[repository_name]
        end

        def to_query
          repositories.map do |repository_owner, repository_name, repository_id|
            "repo:#{repository_owner}/#{repository_name}"
          end.join(' ')
        end

        def empty?
          repositories.empty?
        end

        private

        attr_reader :company

        def repositories
          @repositories ||= company.repositories
            .pluck(:id, :link)
            .map { |id, url| [url.split('/')[-2..-1], id].flatten }
            .compact
        end

        def to_h
          @repositories_map ||= repositories.map do |repository_owner, repository_name, repository_id|
            ["#{repository_owner}/#{repository_name}", repository_id]
          end.to_h
        end
      end
    end
  end
end
