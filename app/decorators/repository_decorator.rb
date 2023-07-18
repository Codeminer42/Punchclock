# frozen_string_literal: true

class RepositoryDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def languages
    return [] unless language

    language.split(', ').map(&:strip)
  end

  def name
    link[/[\w_-]+$/]
  end
end
