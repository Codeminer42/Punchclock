# frozen_string_literal: true

class RepositoryDecorator < ApplicationDecorator
  include ActionView::Helpers::NumberHelper

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def languages
    return [] unless language

    language.split(', ').first(3).map(&:strip)
  end

  def name
    link[/[\w_-]+$/]
  end

  def issues_formatted
    format_number(model.issues)
  end

  def stars_formatted
    format_number(model.stars)
  end

  private

  def format_number(number)
    return number.to_s if number <= 999

    number_to_human(number, precision: 2, separator: '.', units: { thousand: "K", million: "M" }).gsub(/\s+/, '')
  end
end
