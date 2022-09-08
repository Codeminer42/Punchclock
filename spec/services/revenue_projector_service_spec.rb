require 'rails_helper'

RSpec.describe RevenueProjectorService do
  describe ".data_from_allocation" do
    let(:allocation) { build_stubbed(:allocation, hourly_rate: 100, start_at: "2021-10-18", end_at: "2022-03-05") }
    let(:data) { described_class.data_from_allocation(allocation) }

    it "returns a hash containing the total working days and revenue for each month of the allocation" do
      expect(data).to eq([
        { month: 10, year: 2021, working_days: 10, revenue: Money.new(8000_00) },
        { month: 11, year: 2021, working_days: 22, revenue: Money.new(17600_00) },
        { month: 12, year: 2021, working_days: 23, revenue: Money.new(18400_00) },
        { month: 1, year: 2022, working_days: 21, revenue: Money.new(16800_00) },
        { month: 2, year: 2022, working_days: 20, revenue: Money.new(16000_00) },
        { month: 3, year: 2022, working_days: 4, revenue: Money.new(3200_00) }
      ])
    end
  end

  describe ".data_from_project" do
    let(:project) { create(:project) }
    let(:data) { described_class.data_from_project(project) }

    before do
      create(:allocation, project: project, hourly_rate: 25, start_at: "2020-01-11", end_at: "2020-03-11")
      create(:allocation, project: project, hourly_rate: 50, start_at: "2020-11-06", end_at: "2021-11-25")
      create(:allocation, project: project, hourly_rate: 100, start_at: "2021-10-18", end_at: "2022-03-05")
    end

    it "returns a hash containing the total revenue for all project's allocations separated by year and month" do
      expect(data).to eq({
        2020 => {
          1 => Money.new(3000_00),
          2 => Money.new(4000_00),
          3 => Money.new(1600_00),
          11 => Money.new(6800_00),
          12 => Money.new(9200_00)
        },
        2021 => {
          1 => Money.new(8400_00),
          2 => Money.new(8000_00),
          3 => Money.new(9200_00),
          4 => Money.new(8800_00),
          5 => Money.new(8400_00),
          6 => Money.new(8800_00),
          7 => Money.new(8800_00),
          8 => Money.new(8800_00),
          9 => Money.new(8800_00),
          10 => Money.new(840000 + 800000),
          11 => Money.new(760000 + 1760000),
          12 => Money.new(18400_00)
        },
        2022 => {
          1 => Money.new(16800_00),
          2 => Money.new(16000_00),
          3 => Money.new(3200_00)
        }
      })
    end
  end

  describe ".revenue_from_year" do
    let(:project1) { create(:project, :inactive) }
    let(:project2) { create(:project) }
    let(:data) { described_class.revenue_from_year(2020) }

    before do
      create(:allocation, start_at: "2019-01-01", end_at: "2019-12-31")
      create(:allocation, project: project1, hourly_rate: 25, start_at: "2020-01-11", end_at: "2020-03-11")
      create(:allocation, project: project1, hourly_rate: 75, start_at: "2020-11-01", end_at: "2020-11-30")
      create(:allocation, project: project2, hourly_rate: 50, start_at: "2020-11-06", end_at: "2021-11-25")
      create(:allocation, project: project2, hourly_rate: 100, start_at: "2021-10-18", end_at: "2022-03-05")
      create(:allocation, start_at: "2021-01-01", end_at: "2021-12-31")
    end

    it "returns a hash containing the total revenue of the requested year considering only projects with allocations on the year" do
      expect(data).to eq([
        {
          project: project1,
          revenue: {
            1 => Money.new(3000_00),
            2 => Money.new(4000_00),
            3 => Money.new(1600_00),
            11 => Money.new(12600_00)
          }
        },
        {
          project: project2,
          revenue: {
            11 => Money.new(6800_00),
            12 => Money.new(9200_00)
          }
        }
      ])
    end
  end
end
