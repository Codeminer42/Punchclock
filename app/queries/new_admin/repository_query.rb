# frozen_string_literal: true

module NewAdmin
  class RepositoryQuery
    def initialize(languages: [], repository_name_search: nil)
      @repository_name_search = repository_name_search
      @languages              = languages.reject(&:blank?)
    end

    def call
      Repository
        .by_repository_name_like(repository_name_search)
        .by_languages(languages)
        .order(link: :asc)
    end

    private

    attr_reader :repository_name_search, :languages
  end
end
