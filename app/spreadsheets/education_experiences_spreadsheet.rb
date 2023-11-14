# frozen_string_literal: true

class EducationExperiencesSpreadsheet < DefaultSpreadsheet
  def body(education_experience)
    [
      education_experience.id,
      education_experience.user_id,
      education_experience.institution,
      education_experience.course,
      education_experience.start_date,
      education_experience.end_date
    ]
  end

  def header
    %w[
      id
      user_id
      institution
      course
      start_date
      end_date
    ].map { |attribute| EducationExperience.human_attribute_name(attribute) }
  end
end
