# frozen_string_literal: true

module NewAdmin
  class RepositoryQuery
    def initialize(repository_name_search: nil, languages: nil)
      @repository_name_search = repository_name_search
      @languages              = languages
    end

    def call
      Repository
        .by_repository_name_like(repository_name_search)
        .by_languages(languages)
        .order(link: :asc)
    end

    private

    def languages
      if @languages.nil?
        return nil
      end

      @languages.reject(&:blank?)
    end

    attr_reader :repository_name_search
  end
end
