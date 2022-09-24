class ContributionDecorator < Draper::Decorator
  delegate_all

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
end
