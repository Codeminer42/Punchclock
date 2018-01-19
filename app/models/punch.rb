class Punch < ApplicationRecord
  attr_accessor :from_time, :to_time, :when_day

  belongs_to :project
  belongs_to :user
  belongs_to :company

  validates_presence_of :from, :to
  validates [:from, :to], check_time: true
  validates_with WorkableValidator, if: -> { from.present? && user.present? }

  mount_uploader :attachment, AttachmentUploader

  scope :since, ->(time) { where('punches.from >= ?', time) }
  scope :until, ->(time) { where('punches.to <= ?', time) }
  scope :by_days, ->(days) { where('date("punches"."from") in (?)', days) }

  def from_time=(time_string)
    @from_time = time_string.presence
    mount_times
    time_string
  end

  def to_time=(time_string)
    @to_time = time_string.presence
    mount_times
    time_string
  end

  def when_day=(date)
    @when_day = date.presence
    mount_times
    date
  end

  def delta
    (to - from)
  end

  def date
    from.to_date
  end

  def sheet
    as_json(only: [:project_id, :from, :to]).merge(
      delta: (delta/1.hour).round
    )
  end

  def self.total
    all.reduce(0) { |a, e| a + e.delta }
  end

  private

  def mount_time(time_string)
    RelativeTime.new(time_string).relative_to(@when_day)
  end

  def mount_times
    unless @when_day.nil?
      self.to = mount_time(@to_time) unless @to_time.nil?
      self.from = mount_time(@from_time) unless @from_time.nil?
    end
  end
end
