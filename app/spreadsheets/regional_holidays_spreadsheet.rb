# frozen_string_literal: true

class RegionalHolidaysSpreadsheet < BaseSpreadsheet
  def body(regional_holiday)
    [
      regional_holiday.name,
      regional_holiday.day.to_s,
      regional_holiday.month.to_s,
      translate_date(regional_holiday.created_at),
      translate_date(regional_holiday.updated_at)
    ]
  end

  def header
    %w[
      name
      day
      month
      created_at
      updated_at
    ].map { |attribute| RegionalHoliday.human_attribute_name(attribute) }
  end
end
