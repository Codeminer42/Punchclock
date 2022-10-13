# frozen_string_literal: true

class AllocationsSpreadsheet < DefaultSpreadsheet
  def body(allocation)
    [
      allocation.user.name,
      allocation.user.specialty,
      allocation.user.decorate.office_head_name,
      allocation.project&.name,
      translate_date(allocation.end_at)
    ]
  end

  def header
    [
      User.human_attribute_name('name'),
      User.human_attribute_name('specialty'),
      Office.human_attribute_name('head'),
      Allocation.human_attribute_name('project'),
      Allocation.human_attribute_name('end_at')
    ]
  end
end
