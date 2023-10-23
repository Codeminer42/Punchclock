# frozen_string_literal: true

class EducationExperienceDecorator < Draper::Decorator
  delegate_all

  def start_date
    model.start_date.to_date.to_fs(:date)
  end

  def end_date
    if model.end_date.present?
      model.end_date.to_date.to_fs(:date)
    else
      '-'
    end
  end

  def start_year
    model.start_date.to_date.year
  end

  def end_year
    if model.end_date.present?
      model.end_date.to_date.year
    else
      '-'
    end
  end
end
