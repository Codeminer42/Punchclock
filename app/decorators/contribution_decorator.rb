# frozen_string_literal: true

class ContributionDecorator < Draper::Decorator
  delegate_all
  decorates_association :repository
  delegate :name, to: :repository, prefix: :repository, allow_nil: true

  def created_at
    model.created_at.to_date.to_fs(:date)
  end

  def reviewed_by_short_name
    return '' if reviewed_by.nil?

    reviewed_by.first_and_last_name.split.map(&:first).join.upcase
  end

  def reviewed_at
    model.reviewed_at&.to_date&.to_fs(:date)
  end

  def description
    return 'pending description' if model.description.nil?

    model.description
  end

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
