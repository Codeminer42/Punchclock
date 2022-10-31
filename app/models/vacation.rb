# frozen_string_literal: true

class Vacation < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :commercial_approver, class_name: 'User', foreign_key: :commercial_approver_id, optional: true
  belongs_to :administrative_approver, class_name: 'User', foreign_key: :administrative_approver_id, optional: true

  enumerize :status, in: {
    pending: 0,
    approved: 1,
    denied: 2,
    cancelled: 3,
  }, predicates: true, scope: :shallow

  validates :start_date, :end_date, :user, presence: true
  validates :start_date, comparison: { greater_than: Time.zone.today }, if: :not_cancelled?
  validates :end_date, comparison: { greater_than: :start_date }, if: :not_cancelled?

  private

  def not_cancelled?
    status != :cancelled
  end
end
