# frozen_string_literal: true

class AllocationDecorator < Draper::Decorator
  delegate_all

  def hourly_rate
    h.humanized_money_with_symbol(super)
  end

  def to_s
    "##{model.id}"
  end
end
