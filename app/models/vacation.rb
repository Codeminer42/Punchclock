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
  validates_comparison_of :end_date, greater_than: :minimum_vacation_date, if: :not_cancelled?

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

  private

  def validate_approvers_and_approve
    update!(status: :approved) if hr_approver && commercial_approver
  end

  def not_cancelled?
    status != :cancelled
  end

  def minimum_vacation_date
    return unless start_date
    start_date + 5.days
  end
end
