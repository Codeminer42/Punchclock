# frozen_string_literal: true
class AllocationsSpreadsheet < BaseSpreadsheet
  def body(allocation)
    [
      allocation.user.name,
      allocation.project.name,
      translate_date(allocation.start_at),
      translate_date(allocation.end_at),
      translate_date(allocation.created_at),
      translate_date(allocation.updated_at)
    ]
  end

  def header
    %w[
      user
      project
      start_at
      end_at
      created_at
      updated_at
    ].map { |attribute| Allocation.human_attribute_name(attribute) }
  end
end
