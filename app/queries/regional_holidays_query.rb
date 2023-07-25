# frozen_string_literal: true

class RegionalHolidaysQuery
  def initialize(**options)
    @regional_holiday_id = options[:regional_holiday_id]
    @city_ids            = options[:city_ids]
    @month               = options[:month]
  end

  def call
    query = RegionalHoliday.joins(:cities)
    merge_options!(query)

    query.distinct
  end

  private

  attr_reader :regional_holiday_id, :city_ids, :month

  def merge_options!(query)
    query.merge!(by_regional_holiday(query))
    query.merge!(by_cities(query))
    query.merge!(by_month(query))
  end

  def by_regional_holiday(query)
    return query unless regional_holiday_id.present?

    query.where(id: regional_holiday_id)
  end

  def by_cities(query)
    return query unless city_ids.present? && city_ids.reject(&:blank?).present?

    query.where(cities: { id: city_ids })
  end

  def by_month(query)
    return query unless month.present?

    query.where(month: month)
  end
end
