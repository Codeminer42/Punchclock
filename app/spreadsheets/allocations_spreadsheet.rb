# frozen_string_literal: true
class AllocationsSpreadsheet < BaseSpreadsheet
  def body(allocation)
    [
      allocation.user.name,
      allocation.user.specialty,
      allocation.project&.name,
      translate_date(allocation.start_at),
      translate_date(allocation.end_at),
      translate_date(allocation.created_at),
      translate_date(allocation.updated_at)
    ]
  end

  def header
    [
      User.human_attribute_name('name'),
      User.human_attribute_name('specialty'),
      Allocation.human_attribute_name('project'),
      Allocation.human_attribute_name('start_at'),
      Allocation.human_attribute_name('end_at'),
      Allocation.human_attribute_name('created_at'),
      Allocation.human_attribute_name('updated_at'),
    ]
  end
end
