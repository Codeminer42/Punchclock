# frozen_string_literal: true

class HourReportSpreadsheet < BaseSpreadsheet
  def body(report)
    [
      report.user.name,
      report.user.email,
      report.user.office&.city,
      report.project.to_s,
      report.hours
    ]
  end

  def header
    %w[
      name
      email
      office
      project
      hours
    ].map { |attribute| HourReport.human_attribute_name(attribute) }
  end
end
