module HasDateRange
  extend ActiveSupport::Concern

  included do
    validate :valid_overlap

    scope :contains, ->(d){ DateOverlapQuery.new(self).contains d }
    scope :intersect, ->(r){ DateOverlapQuery.new(self).intersect r }
    scope :currents, -> { contains Date.current }
  end

  def range
    start_at..end_at
  end

  def range=(range)
    self.start_at = range.min
    self.end_at = range.max
  end

  def siblings
    self.class
  end

  protected

  def valid_overlap
    errors[:base] << :overlap if siblings.intersect(range).any?
  end
end
