class Punch < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :company

  has_one :comment

  validates_presence_of :from, :to, :project_id, :user_id, :company_id
  validate :check_time

  mount_uploader :attachment, AttachmentUploader

  accepts_nested_attributes_for :comment, allow_destroy: true

  scope :since, lambda {|time| where("punches.from >= ?", time) }
  scope :until, lambda {|time| where("punches.to <= ?", time) }

  def delta
    self.to - self.from
  end

  def self.total
    self.all.reduce(0) do |total, punch|
      total += punch.delta 
    end
  end
    
  private
  def check_time
    if self.from.present? && self.to.present?
      if self.to < self.from
        errors.add(:from, "can't be greater than From time")
      end

      if self.from.to_date != self.to.to_date
        errors.add(:to, "can't be in diferent dates")
      end

      if Time.now < self.to.to_date
        errors.add(:to, "can't be in the future, take your time machine and go back")
      end
    end
  end
end
