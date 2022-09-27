# frozen_string_literal: true

class ProjectDecorator < Draper::Decorator
  delegate_all

  def market
    return super.text if super

    'N/A'
  end
end
