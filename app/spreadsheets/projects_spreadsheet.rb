# frozen_string_literal: true

class ProjectsSpreadsheet < BaseSpreadsheet
  def body(project)
    [
      project.name,
      project.active.to_s,
      project.client&.name,
      project.company&.name,
      translate_date(project.created_at),
      translate_date(project.created_at)
    ]
  end

  def header
    %w[
      name
      active
      client
      company
      created_at
      updated_at
    ].map { |attribute| Project.human_attribute_name(attribute) }
  end
end
