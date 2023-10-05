# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def current_allocation
    super || ENV["DEFAULT_PROJECT_NAME"] || I18n.t('not_allocated')
  end

  def frontend_level
    return 'N/A' unless model.frontend_level

    "Frontend #{model.frontend_level.humanize}"
  end

  def backend_level
    return 'N/A' unless model.backend_level

    "Backend #{model.backend_level.humanize}"
  end

  def specialty
    model.specialty.try(:humanize) || 'N/A'
  end

  def contract_type
    model.contract_type.try(:humanize) || 'N/A'
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

  def office_head_name
    model.office.head&.name || 'N/A'
  end

  def skills
    model.skills.pluck(:title).to_sentence
  end

  def roles_text
    model.roles.values.to_sentence.humanize(capitalize: false)
  end

  def city_text
    return if model.city.nil?
    "#{model.city.name} - #{model.city.state.code}"
  end

  def offices_managed
    model.managed_offices.pluck(:city).to_sentence
  end

  def roles_sentence
    roles = model.roles.values.reduce([]) do |acc, role|
      acc.push(I18n.t("user.role.#{role}"))
    end

    roles.to_sentence.humanize
  end

  def mentor_name
    return if model.mentor.nil?
    model.mentor.first_and_last_name
  end

  def office_city
    model.office.city
  end
end
