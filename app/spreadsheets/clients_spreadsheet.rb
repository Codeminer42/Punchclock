# frozen_string_literal: true

class ClientsSpreadsheet < BaseSpreadsheet
  def body(client)
    [
      client.name,
      client.company&.name,
      client.active.to_s,
      translate_date(client.created_at),
      translate_date(client.created_at)
    ]
  end

  def header
    %w[
      name
      company
      active
      created_at
      updated_at
    ].map { |attribute| Client.human_attribute_name(attribute) }
  end
end
