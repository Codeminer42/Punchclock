# frozen_string_literal: true

class RepositoryDecorator < ApplicationDecorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def languages
    return [] unless language

    language.split(', ').first(3).map(&:strip)
  end

  def issues_formatted
    format_number(model.issues)
  end

  def stars_formatted
    format_number(model.stars)
  end

  def name
    link[/[\w_-]+$/]
  end

  private

  def format_number(number)
    if number >= 1000
      "#{(number/1000).round(1)}K"
    else
      number
    end
  end
end
