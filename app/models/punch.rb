class Punch < ActiveRecord::Base
  attr_accessor :from_time, :to_time, :when_day

  belongs_to :project
  belongs_to :user
  belongs_to :company
  belongs_to :period

  validates_presence_of :from, :to, :project_id, :user_id, :company_id
  validates [:from, :to], check_time: true

  before_save :attatch_to_period

  mount_uploader :attachment, AttachmentUploader

  scope :since, ->(time) { where('punches.from >= ?', time) }
  scope :until, ->(time) { where('punches.to <= ?', time) }
  scope :wrongs, -> { where period_id: nil }
  scope :by_days, ->(days) { where('date("punches"."from") in (?)', days) }

  def self.fix_all
    wrongs.each { |punch| punch.save }
  end

  def from_time=(time_string)
    @from_time = time_string
    mount_times
    time_string
  end

  def to_time=(time_string)
    @to_time = time_string
    mount_times
    time_string
  end

  def when_day=(date)
    @when_day = date
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

  def attatch_to_period
    self.period = company.periods.contains_or_create from.to_date
  end

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
