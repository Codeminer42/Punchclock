# frozen_string_literal: true

class CompaniesSpreadsheet < BaseSpreadsheet
  def body(company)
    [
      company.name,
      translate_date(company.created_at),
      translate_date(company.created_at)
    ]
  end

  def header
    %w[
      name
      created_at
      updated_at
    ].map { |attribute| Company.human_attribute_name(attribute) }
  end
end
