# frozen_string_literal: true

class EducationExperienceDecorator < Draper::Decorator
  delegate_all

  def start_date
    model.start_date.to_date.to_fs(:date)
  end

  def end_date
    model.start_date.to_date.to_fs(:date)
  end
end
