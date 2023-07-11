# frozen_string_literal: true

class EducationExperienceDecorator < Draper::Decorator
  delegate_all

  def start_date
    model.start_date.to_date.to_fs(:date)
  end

  def end_date
    model.end_date.to_date.to_fs(:date)
  end

  def start_year
    model.start_date.to_date.year
  end

  def end_year
    model.end_date.to_date.year
  end
end
