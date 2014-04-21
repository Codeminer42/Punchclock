class Period < ActiveRecord::Base
  @@DEFAULT_END_PERIOD = 15
  belongs_to :company
  validates_associated :company
  include HasDateRange

  def self.contains_or_create(date)
    contains(date).
      first_or_create range: calculate_range_from(date, end_period)
  end

  def self.end_period
    new.company.try(:end_period) || @@DEFAULT_END_PERIOD
  end

  def siblings
    company.periods.siblings(id)
  end

  protected

  def self.calculate_range_from(date, day_base)
    start = date.change day: day_base
    start = start.prev_month if start > date
    finish = start.next_month

    start..finish
  end
end
