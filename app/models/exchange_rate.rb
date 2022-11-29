class ExchangeRate < ApplicationRecord
  extend Enumerize

  enumerize :currency, in: %w[USD]

  validates_presence_of :currency, :month, :year, :rate

  validates_numericality_of :month, :year, only_integer: true
  validates_numericality_of :month, greater_than_or_equal_to: 1, less_than_or_equal_to: 12
  validates_numericality_of :year, greater_than: 2020
  validates_numericality_of :rate, greater_than_or_equal_to: 1

  validates_uniqueness_of :month, scope: %i[year currency]

  def self.newest_by_month_and_year(month, year)
    same_year_rate = where(month: ...month, year:).order(month: :desc).first
    same_year_rate || where(year: ...year).order(year: :desc).order(month: :desc).first
  end
end
