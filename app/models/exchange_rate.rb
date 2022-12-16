class ExchangeRate < ApplicationRecord
  extend Enumerize

  enumerize :currency, in: %w[USD]

  validates_presence_of :currency, :year, :rate

  validates_numericality_of :year, greater_than: 2010, only_integer: true
  validates_numericality_of :rate, greater_than_or_equal_to: 1

  validates_uniqueness_of :year, scope: :currency
end
