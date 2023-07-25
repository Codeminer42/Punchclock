# frozen_string_literal: true

class RegionalHolidayDecorator < Draper::Decorator
  delegate_all

  def cities
    model.cities.map(&:name).join(', ')
  end
end
