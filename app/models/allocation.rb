# frozen_string_literal: true

class Allocation < ApplicationRecord
  HOURLY_RATE_CURRENCIES = %w[BRL USD]
  DEFAULT_HOURLY_RATE_FOR_PROJECTS = 0

  belongs_to :user
  belongs_to :project

  monetize :hourly_rate_cents, with_model_currency: :hourly_rate_currency

  validates :user, :project, :start_at, :end_at, :hourly_rate_currency, presence: true
  validates_date :start_at
  validates_date :end_at, after: ->(a) { a.start_at }
  validate :unique_period, unless: :end_before_start?
  validates :ongoing, uniqueness: { scope: :user, message: :uniqueness },
                      if: :ongoing?

  delegate :office_name, to: :user
  delegate :name, to: :project, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true, allow_nil: true

  scope :ongoing, lambda {
    where(ongoing: true, user_id: User.active).order(start_at: :desc)
  }

  scope :finished, lambda {
                     where(ongoing: false, user_id: User.active).order(end_at: :desc)
                   }
  scope :in_period, lambda { |start_at, end_at|
    where(
      "daterange(start_at, end_at, '[]') && daterange(:start_at, :end_at, '[]')",
      start_at:,
      end_at:
    )
  }

  def days_until_finish
    return unless end_at

    if ongoing
      (end_at - Date.current).to_i
    elsif end_at > Time.zone.today
      I18n.t('not_started')
    else
      I18n.t('finished')
    end
  end

  def self.hourly_rate_currencies
    select(:hourly_rate_currency).distinct.pluck(:hourly_rate_currency)
  end

  def user_punches
    project
      .punches
      .where(user:)
      .since(start_at)
      .order(from: :desc)
      .decorate
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at end_at hourly_rate_cents hourly_rate_currency id ongoing project_id start_at
       updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[project user]
  end

  private

  def end_before_start?
    end_at.present? && end_at < start_at
  end

  def unique_period
    return unless Allocation.in_period(start_at, end_at).where.not(id:).exists?(user_id:)

    errors.add(:start_at, :overlapped_period)
  end
end
