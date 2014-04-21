class Period < ActiveRecord::Base
  @@DEFAULT_END_PERIOD = 15

  belongs_to :company
  validate :valid_overlap, if: :company

  scope :contains, lambda{ |date|
    where t[:start_at].lt(date).or t[:start_at].gt(date)
  }

  scope :currents, -> { contains Date.current }

  def self.t
    arel_table
  end

  def self.contains_or_create(date)
    contains(date).first_or_create(
      range: calculate_range_from(date, end_period)
    )
  end

  def self.end_period
    new.company.try(:end_period) || @@DEFAULT_END_PERIOD
  end

  def range
    start_at..end_at
  end

  def range=(range)
    self.start_at = range.min
    self.end_at = range.max
  end

  def previous
    company.reload
    company.periods.last
  end

  def overlap?(period)
    overlap_range? period.try :range
  end

  def overlap_range?(range)
    (range.include?(range.min) || range.include?(range.max)) if range
  end

  protected

  def self.calculate_range_from(date, day_base)
    start = date.change day: day_base
    start = start.prev_month if start > date
    finish = start.next_month - 1.day

    start..finish
  end

  def valid_overlap
    errors[:base] << 'Overlap' if overlap? previous
  end
end
