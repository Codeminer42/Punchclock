# frozen_string_literal: true

class Allocation < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :company

  validates :user, :project, presence: true
  validates_date :start_at
  validate :end_date
  validate :unique_period, unless: :end_before_start?

  delegate :office_name, to: :user

  scope :ongoing, -> { where("end_at > :today OR end_at is NULL", today: Date.current).order(start_at: :desc) }
  scope :finished, -> { where("end_at < :today", today: Date.current).order(end_at: :desc) }
  scope :in_period, -> (start_at, end_at) do
    where(
      "daterange(start_at, end_at, '[]') && daterange(:start_at, :end_at, '[]')",
      start_at: start_at,
      end_at: end_at
    )
  end
  
  def days_until_finish
    return unless end_at

    end_at > Date.current ? (end_at - Date.current).to_i : I18n.t('finished')
  end

  def user_punches
    project
      .punches
      .where(user: user)
      .since(start_at)
      .order(from: :desc)
      .decorate
  end

  private
  
  def end_before_start?
    end_at.present? && end_at < start_at
  end

  def end_date
    errors.add(:end_at, :cant_be_lesser) if end_before_start?
  end

  def unique_period
    return unless Allocation.in_period(start_at, end_at).where.not(id: id).exists?(user_id: user_id)
  
    errors.add(:start_at, :overlapped_period)
  end
end
