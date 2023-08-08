# frozen_string_literal: true

class VacationDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
