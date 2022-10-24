# frozen_string_literal: true

class OfficesSpreadsheet < DefaultSpreadsheet
  def body(office)
    [
      office.city,
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
      head
      users_quantity
      score
      created_at
      updated_at
    ].map { |attribute| Office.human_attribute_name(attribute) }
  end
end
