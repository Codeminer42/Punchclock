# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :punches

  def current_allocation
    current_allocation = model.current_allocation
    if current_allocation.present?
      h.link_to current_allocation.name, [:admin, current_allocation]
    else
      I18n.t('not_allocated')
    end
  end

  def role
    model.role.try(:humanize) || 'N/A'
  end

  def specialty
    model.specialty.try(:humanize) || 'N/A'
  end

  def english_level
    model.english_level.try(:humanize) || I18n.t('not_evaluated')
  end

  def english_score
    model.english_score || I18n.t('not_evaluated')
  end

  def performance_score
    model.performance_score || I18n.t('not_evaluated')
  end

  def overall_score
    model.overall_score || I18n.t('not_evaluated')
  end
end
