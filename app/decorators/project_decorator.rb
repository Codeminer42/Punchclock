# frozen_string_literal: true

class ProjectDecorator < Draper::Decorator
  delegate_all

  def market
    return super.text if super

    'N/A'
  end

  def active_class
    active? ? 'fill-green-500' : 'fill-none'
  end
end
