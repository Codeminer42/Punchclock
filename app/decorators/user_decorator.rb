# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def current_allocation
    super || I18n.t('not_allocated')
  end

  def level
    model.level.try(:humanize) || 'N/A'
  end

  def specialty
    model.specialty.try(:humanize) || 'N/A'
  end

  def contract_type
    model.contract_type.try(:humanize) || 'N/A'
  end

  def role
    model.role.try(:humanize) || 'N/A'
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
