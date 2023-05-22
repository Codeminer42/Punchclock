# frozen_string_literal: true

class Vacation < ApplicationRecord
  extend Enumerize

  MINIMUM_DAYS_TO_CANCEL = 7
  MINIMUM_RANGE_OF_DAYS = 8

  belongs_to :user
  belongs_to :hr_approver, class_name: 'User', foreign_key: :hr_approver_id, optional: true
  belongs_to :commercial_approver, class_name: 'User', foreign_key: :commercial_approver_id, optional: true
  belongs_to :denier, class_name: 'User', foreign_key: :denier_id, optional: true

  enumerize :status, in: {
    pending: 0,
    approved: 1,
    denied: 2,
    cancelled: 3,
  }, predicates: true, scope: :shallow

  validates_presence_of :start_date, :end_date, :user
  validates_comparison_of :start_date,
    message: lambda { |vacation, other|
      I18n.t(
        "activerecord.errors.models.vacation.attributes.start_date.greater_than_current",
        date: I18n.l(Date.current)
      )
    },
    greater_than: Date.current,
    allow_nil: true,
    if: :not_cancelled?
  validates_comparison_of :end_date,
    message: lambda { |vacation, other|
      I18n.t(
        "activerecord.errors.models.vacation.attributes.end_date.greater_than_current",
        date: I18n.l(vacation.start_date + MINIMUM_RANGE_OF_DAYS.days)
      )
    },
    greater_than: lambda { |vacation| vacation.start_date + MINIMUM_RANGE_OF_DAYS.days },
    allow_nil: true,
    if: :not_cancelled?
  validate :validate_start_date_close_to_weekend, if: :start_date, unless: proc { user.contractor? }
  validates_with HolidayValidator, if: :start_date, unless: lambda { !validate_vacation_before_holiday? }

  scope :ongoing_and_scheduled, -> {
    where(status: :approved)
    .where("end_date >= :today", today: Date.current)
    .order(start_date: :asc, end_date: :asc)
  }

  scope :expired, -> {
    pending
    .where("start_date < :today", today: Date.current)
    .order(start_date: :asc, end_date: :asc)
  }

  scope :pending_approval_of, ->(approver) {
    unless [:hr, :commercial].include? approver.to_sym
      raise ArgumentError, "The approver should be :hr or :commercial"
    end
    where("#{approver}_approver_id": nil)
  }

  scope :finished, -> {
    approved
    .where("end_date <= :today", today: Date.current)
    .order(end_date: :desc)
  }

  def approve!(user)
    ActiveRecord::Base.transaction do
      update!(hr_approver: user) if user.hr?
      update!(commercial_approver: user) if user.commercial?

      validate_approvers_and_approve
    end
  end

  def deny!(user)
    if user.commercial? || user.hr?
      ActiveRecord::Base.transaction do
        update!(status: :denied, denier: user)
      end
    end
  end

  def cancelable?
    pending? || approved_within_cancel_range?
  end

  def duration_days
    (start_date..end_date).count
  end

  private

  def approved_within_cancel_range?
    start_date.days_ago(MINIMUM_DAYS_TO_CANCEL) >= Date.today
  end

  def validate_approvers_and_approve
    update!(status: :approved) if hr_approver && commercial_approver
  end

  def not_cancelled?
    status != :cancelled
  end

  def validate_start_date_close_to_weekend
    if start_date.thursday? || start_date.friday? || start_date.on_weekend?
      errors.add(:start_date, :close_weekend)
    end
  end

  def validate_vacation_before_holiday?
    ENV['VALIDATE_VACATION_BEFORE_HOLIDAY'] == 'true'
  end
end
