# frozen_string_literal: true

class Vacation < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :hr_approver, class_name: 'User', foreign_key: :hr_approver_id, optional: true
  belongs_to :project_manager_approver, class_name: 'User', foreign_key: :project_manager_approver_id, optional: true
  belongs_to :denier, class_name: 'User', foreign_key: :denier_id, optional: true

  enumerize :status, in: {
    pending: 0,
    approved: 1,
    denied: 2,
    cancelled: 3,
  }, predicates: true, scope: :shallow

  validates :start_date, :end_date, :user, presence: true
  validates :start_date, comparison: { greater_than: Time.zone.today }, if: :not_cancelled?
  validates :end_date, comparison: { greater_than: :start_date }, if: :not_cancelled?

  def approve!(user)
    ActiveRecord::Base.transaction do
      update!(hr_approver: user) if user.hr?
      update!(project_manager_approver: user) if user.project_manager?

      validate_approvers_and_approve
    end
  end

  def deny!(user)
    if user.project_manager? || user.hr?
      ActiveRecord::Base.transaction do
        update!(status: :denied)
        update!(denier: user)
      end
    end
  end

  private

  def validate_approvers_and_approve
    if hr_approver && project_manager_approver
      update!(status: :approved)
    end
  end

  def not_cancelled?
    status != :cancelled
  end
end
