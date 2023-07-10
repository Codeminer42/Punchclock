# frozen_string_literal: true

class ProfessionalExperienceDecorator < Draper::Decorator
  delegate_all

  def end_date
    return I18n.t(:present) if model.end_date.blank?

    model.end_date
  end

  def start_date_month
    I18n.l(model.start_date.to_date, format: :month_and_year)
  end

  def end_date_month
    return end_date if model.end_date.blank?

    I18n.l(end_date.to_date, format: :month_and_year)
  end
end
