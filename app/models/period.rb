class Period < ActiveRecord::Base
  belongs_to :company
  validate :valid_overlap, if: :company

  scope :contains, ->(date) {
    where 'start_at < ? and end_at > ? ', date, date
  }
  scope :currents, -> { contains Date.current }
  
  def self.contains_or_create date
    contains(date).first_or_create range:  15.days.ago..15.days.from_now
  end

  def range
    start_at..end_at
  end

  def range= range
    self.start_at = range.min
    self.end_at = range.max
  end

  def overlap? period
    period && 
      (range.include?(period.range.min) || range.include?(period.range.max))
  end

  protected

  def valid_overlap
    errors[:base] << 'Overlap' if overlap? company.reload.try(:periods).try :last
  end
end
