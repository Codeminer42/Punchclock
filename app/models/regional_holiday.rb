class RegionalHoliday < ActiveRecord::Base
  has_and_belongs_to_many :offices
  validates :name, :day, :month, presence: true
  validate :date_validation

  def cities
    offices.map(&:city)
  end

  private

  def valid_date?
    day.present? && month.present? &&
      Date.valid_date?(Date.today.year, month, day)
  end

  def date_validation
    errors.add(:base, 'date must be valid') unless valid_date?
  end
end
