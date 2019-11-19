# frozen_string_literal: true

class OfficesSpreadsheet < BaseSpreadsheet
  def body(office)
    [
      office.city,
      office.company&.name,
      office.head&.name,
      office.users.active.size,
      office.score,
      translate_date(office.created_at),
      translate_date(office.updated_at)
    ]
  end

  def header
    %w[
      city
      company
      head
      users_quantity
      score
      created_at
      updated_at
    ].map { |attribute| Office.human_attribute_name(attribute) }
  end
end
