# frozen_string_literal: true

class Vacation < ApplicationRecord
  extend Enumerize

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
  validates_comparison_of :start_date, greater_than: Date.current, if: :not_cancelled?
  validate :minimum_vacation_date, if: :not_cancelled?

  scope :ongoing_and_scheduled, -> {
    where(status: :approved)
    .where("end_date >= :today", today: Date.current)
    .order(start_date: :asc, end_date: :asc)
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
    self.pending? || approved_within_cancel_range?
  end

  private

  MINIMUM_DAYS_TO_CANCEL = 7

  def approved_within_cancel_range?
    (self.start_date.days_ago(MINIMUM_DAYS_TO_CANCEL) >= Date.today)
  end

  def validate_approvers_and_approve
    update!(status: :approved) if hr_approver && commercial_approver
  end

  def not_cancelled?
    status != :cancelled
  end

  def minimum_vacation_date
    return unless start_date
    errors.add(:base, :must_be_higher_than_10) if ((end_date - start_date) < 10)
  end
end
