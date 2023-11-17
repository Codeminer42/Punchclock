# frozen_string_literal: true

module NewAdmin
  class NotesQuery
    def initialize(filters)
      self.filters = filters
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      Note.order(title: :asc)
          .by_title_like(filters[:title])
          .by_user(filters[:user_id])
          .by_author(filters[:author_id])
          .by_rate(filters[:rate])
    end

    private

    attr_accessor :filters
  end
end
