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
    cancelled: 3
  }, predicates: true, scope: :shallow

  validates_presence_of :start_date, :end_date, :user
  validates_comparison_of :start_date,
                          message: lambda { |_vacation, _other|
                            I18n.t(
                              "activerecord.errors.models.vacation.attributes.start_date.greater_than_current",
                              date: I18n.l(Date.current)
                            )
                          },
                          greater_than: ->(_) { Date.current },
                          allow_nil: true,
                          if: :not_cancelled?
  validates_comparison_of :end_date,
                          message: lambda { |vacation, _other|
                            I18n.t(
                              "activerecord.errors.models.vacation.attributes.end_date.greater_than_current",
                              date: I18n.l(vacation.start_date + MINIMUM_RANGE_OF_DAYS.days)
                            )
                          },
                          greater_than: ->(vacation) { vacation.start_date + MINIMUM_RANGE_OF_DAYS.days },
                          allow_nil: true,
                          if: :not_cancelled?
  validate :validate_start_date_close_to_weekend, if: :start_date, unless: -> { user.contractor? }
  validates_with HolidayValidator, if: :start_date, unless: -> { !validate_vacation_before_holiday? }

  scope :ongoing_and_scheduled, lambda {
    where(status: :approved)
      .where("end_date >= :today", today: Date.current)
      .order(start_date: :asc, end_date: :asc)
  }

  scope :expired, lambda {
    pending
      .where("start_date < :today", today: Date.current)
      .order(start_date: :asc, end_date: :asc)
  }

  scope :pending_approval_of, lambda { |approver|
    raise ArgumentError, "The approver should be :hr or :commercial" unless %i[hr commercial].include? approver.to_sym

    where("#{approver}_approver_id": nil)
  }

  scope :finished, lambda {
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
    update!(status: :denied, denier: user)
  end

  def cancel!(user)
    update!(status: :cancelled, denier: user)
  end

  def cancelable?
    pending? || approved_within_cancel_range?
  end

  def duration_days
    (start_date..end_date).count
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[commercial_approver denier hr_approver user]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[commercial_approver_id created_at denier_id end_date hr_approver_id id start_date status
       updated_at user_id]
  end

  private

  def approved_within_cancel_range?
    start_date.days_ago(MINIMUM_DAYS_TO_CANCEL) >= Date.current
  end

  def validate_approvers_and_approve
    update!(status: :approved) if hr_approver && commercial_approver
  end

  def not_cancelled?
    status != :cancelled
  end

  def validate_start_date_close_to_weekend
    return unless start_date.thursday? || start_date.friday? || start_date.on_weekend?

    errors.add(:start_date, :close_weekend)
  end

  def validate_vacation_before_holiday?
    ENV['VALIDATE_VACATION_BEFORE_HOLIDAY'] == 'true'
  end
end
