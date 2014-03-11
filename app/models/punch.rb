class Punch < ActiveRecord::Base
  attr_accessor :from_time, :to_time, :when_day

  belongs_to :project
  belongs_to :user
  belongs_to :company

  validates_presence_of :from, :to, :project_id, :user_id, :company_id
  validates [:from, :to], check_time: true

  mount_uploader :attachment, AttachmentUploader

  scope :since, lambda {|time| where("punches.from >= ?", time) }
  scope :until, lambda {|time| where("punches.to <= ?", time) }

  def from_time= time_string
    @from_time = time_string
    mount_times
    time_string
  end

  def to_time= time_string
    @to_time = time_string
    mount_times
    time_string
  end

  def when_day= date
    @when_day = date
    mount_times
    date
  end

  def delta
    (self.to - self.from)
  end

  def self.total
    self.all.reduce(0) do |total, punch|
      total += punch.delta
    end
  end

  private
  def mount_time time_string
    RelativeTime.new(time_string).relative_to(@when_day)
  end

  def mount_times
    unless @when_day.nil?
      self.to = mount_time(@to_time) unless @to_time.nil?
      self.from = mount_time(@from_time) unless @from_time.nil?
    end
  end
end
