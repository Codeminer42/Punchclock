# frozen_string_literal: true

class RegionalHolidayDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def cities
    model.cities.map(&:name).join(', ')
  end
end
