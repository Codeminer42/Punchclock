class ContributionDecorator < Draper::Decorator
  delegate_all

  def user_short_name
    user.name.split.values_at(0, -1).uniq.join(' ')
  end

  def created_at
    model.created_at.strftime("%d/%m/%Y")
  end

  def reviewed_by_short_name
    reviewed_by.name.empty? ? '' : reviewed_by.name.split.values_at(0, -1).uniq.map(&:first).join.upcase
  end

  def reviewed_at
    model.reviewed_at.strftime("%d/%m/%Y")
  end

end
