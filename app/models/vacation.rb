# frozen_string_literal: true

class Vacation < ApplicationRecord
  attr_accessor :starting_day, :ending_day
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
  validates :end_date, comparison: { greater_than: :start_date }
  validates :start_date, comparison: { greater_than: Time.zone.today }

  def starting_day=(date)
    @starting_day = date.presence
    mount_start_date
    date
  end

  def ending_day=(date)
    @ending_day = date.presence
    mount_end_date
    date
  end

  private

  def mount_start_date
    self.start_date = @starting_day unless @starting_day.nil?
  end

  def mount_end_date
    self.end_date = @ending_day unless @ending_day.nil?
  end
end
