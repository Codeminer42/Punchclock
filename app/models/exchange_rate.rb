class ExchangeRate < ApplicationRecord
  extend Enumerize

  enumerize :currency, in: %w[USD]

  validates_presence_of :currency, :month, :year, :rate

  validates_numericality_of :month, :year, only_integer: true
  validates_numericality_of :month, greater_than_or_equal_to: 1, less_than_or_equal_to: 12
  validates_numericality_of :year, greater_than: 2010
  validates_numericality_of :rate, greater_than_or_equal_to: 1

  validates_uniqueness_of :month, scope: %i[year currency]

  def self.for_month_and_year!(month, year)
    beginning_of_current_month = Date.current.beginning_of_month
    beginning_of_requested_month = Date.new(year, month, 1)

    date_to_fetch = if beginning_of_current_month <= beginning_of_requested_month
                      beginning_of_current_month - 1.day
                    else
                      beginning_of_requested_month - 1.day
                    end

    find_by!(month: date_to_fetch.month, year: date_to_fetch.year)
  end
end
