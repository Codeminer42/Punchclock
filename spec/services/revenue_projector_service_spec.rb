require 'rails_helper'

RSpec.describe RevenueProjectorService do
  describe "#data_from_allocation" do
    let(:allocation) { build_stubbed(:allocation, hourly_rate: 100, start_at: "2021-10-18", end_at: "2022-03-05") }
    let(:data) { described_class.data_from_allocation(allocation) }

    it "returns a hash containing the months of the allocation" do
      expect(data).to eq([
        { month: "10.2021", working_days: 10, revenue: Money.new(800000) },
        { month: "11.2021", working_days: 22, revenue: Money.new(1760000) },
        { month: "12.2021", working_days: 23, revenue: Money.new(1840000) },
        { month: "01.2022", working_days: 21, revenue: Money.new(1680000) },
        { month: "02.2022", working_days: 20, revenue: Money.new(1600000) },
        { month: "03.2022", working_days: 4, revenue: Money.new(320000) }
      ])
    end
  end
end
