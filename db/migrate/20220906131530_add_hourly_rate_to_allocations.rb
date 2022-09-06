class AddHourlyRateToAllocations < ActiveRecord::Migration[7.0]
  def change
    add_monetize :allocations, :hourly_rate, default: 0
  end
end
