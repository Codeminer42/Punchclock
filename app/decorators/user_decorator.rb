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

  def level
    model.level.try(:humanize) || 'N/A'
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

  def allow_overtime
    I18n.t(model.allow_overtime) || 'N/A'
  end

  def active
    I18n.t(model.active) || 'N/A'
  end

  def started_at
    return if model.started_at.nil?
    I18n.l(user.started_at)
  end

  def office_city
    model.office.city
  end

  def otp_required_for_login
    return I18n.t('false') if model.otp_required_for_login.nil?
    I18n.t(model.otp_required_for_login)
  end
end
