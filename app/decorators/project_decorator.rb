# frozen_string_literal: true

class ProjectDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def market
    return super.text if super

    'N/A'
  end

  def truncated_name
    name.truncate_words 1
  end
end
