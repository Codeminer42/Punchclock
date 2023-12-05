require 'rails_helper'

RSpec.describe RevenueForecastService do
  describe ".allocation_forecast" do
    let(:allocation) { build_stubbed(:allocation, hourly_rate: 100, start_at: "2021-10-18", end_at: "2022-03-05") }
    let(:data) { described_class.allocation_forecast(allocation) }

    it "returns a hash containing the total working days and forecast for each month of the allocation" do
      expect(data).to eq([
                           { month: 10, year: 2021, working_hours: 80, forecast: Money.new(800_000) },
                           { month: 11, year: 2021, working_hours: 160, forecast: Money.new(1_600_000) },
                           { month: 12, year: 2021, working_hours: 160, forecast: Money.new(1_600_000) },
                           { month: 1, year: 2022, working_hours: 160, forecast: Money.new(1_600_000) },
                           { month: 2, year: 2022, working_hours: 160, forecast: Money.new(1_600_000) },
                           { month: 3, year: 2022, working_hours: 32, forecast: Money.new(320_000) }
                         ])
    end

    context 'when allocation currency is USD' do
      let(:allocation) do
        build_stubbed(:allocation, hourly_rate: Money.new(100_00, 'USD'), start_at: "2021-10-18", end_at: "2022-03-05")
      end

      it "returns the forecasts on their currency" do
        expect(data).to eq([
                             { month: 10, year: 2021, working_hours: 80, forecast: Money.new(800_000, 'USD') },
                             { month: 11, year: 2021, working_hours: 160, forecast: Money.new(1_600_000, 'USD') },
                             { month: 12, year: 2021, working_hours: 160, forecast: Money.new(1_600_000, 'USD') },
                             { month: 1, year: 2022, working_hours: 160, forecast: Money.new(1_600_000, 'USD') },
                             { month: 2, year: 2022, working_hours: 160, forecast: Money.new(1_600_000, 'USD') },
                             { month: 3, year: 2022, working_hours: 32, forecast: Money.new(320_000, 'USD') }
                           ])
      end
    end

    context 'when allocation starts and ends in the same month' do
      let(:allocation) { build_stubbed(:allocation, hourly_rate: 100, start_at: "2022-10-04", end_at: "2022-10-17") }

      it "returns a hash containing the total working days and forecast for the single month of allocation" do
        expect(data).to eq([
                             { month: 10, year: 2022, working_hours: 80, forecast: Money.new(800_000) }
                           ])
      end
    end
  end

  describe ".project_forecast" do
    let(:project) { create(:project) }
    let(:data) { described_class.project_forecast(project) }

    before do
      create(:allocation, hourly_rate: 15, start_at: "2020-01-11", end_at: "2020-03-11")
      create(:allocation, project:, hourly_rate: 25, start_at: "2020-01-11", end_at: "2020-03-11")
      create(:allocation, project:, hourly_rate: 50, start_at: "2020-11-06", end_at: "2021-11-25")
      create(:allocation, project:, hourly_rate: 100, start_at: "2021-10-18", end_at: "2022-03-05")
      create(:allocation, hourly_rate: 150, start_at: "2021-10-18", end_at: "2022-03-05")
    end

    it "returns a hash containing the total forecasts for all project's allocations separated by year and month" do
      expect(data).to eq({
                           2020 => {
                             1 => Money.new(300_000),
                             2 => Money.new(400_000),
                             3 => Money.new(160_000),
                             11 => Money.new(680_000),
                             12 => Money.new(800_000)
                           },
                           2021 => {
                             1 => Money.new(800_000),
                             2 => Money.new(800_000),
                             3 => Money.new(800_000),
                             4 => Money.new(800_000),
                             5 => Money.new(800_000),
                             6 => Money.new(800_000),
                             7 => Money.new(800_000),
                             8 => Money.new(800_000),
                             9 => Money.new(800_000),
                             10 => Money.new(800_000 + 800_000),
                             11 => Money.new(760_000 + 1_600_000),
                             12 => Money.new(1_600_000)
                           },
                           2022 => {
                             1 => Money.new(1_600_000),
                             2 => Money.new(1_600_000),
                             3 => Money.new(320_000)
                           }
                         })
    end

    context "when the allocation currency isn't BRL" do
      let(:data) { described_class.project_forecast(allocation.project) }
      let(:allocation) do
        create(:allocation, hourly_rate: 100, hourly_rate_currency: "USD", start_at: "2021-10-18", end_at: "2022-03-05")
      end

      it "returns the data normally without conversion" do
        expect(data).to eq({
                             2021 => {
                               10 => Money.new(800_000, 'USD'),
                               11 => Money.new(1_600_000, 'USD'),
                               12 => Money.new(1_600_000, 'USD')
                             },
                             2022 => {
                               1 => Money.new(1_600_000, 'USD'),
                               2 => Money.new(1_600_000, 'USD'),
                               3 => Money.new(320_000, 'USD')
                             }
                           })
      end
    end
  end

  describe ".year_forecast" do
    let(:project1) { create(:project, :inactive, market: :internal) }
    let(:project2) { create(:project, market: :international) }
    let(:data) { described_class.year_forecast(2020) }

    before do
      create(:allocation, start_at: "2019-01-01", end_at: "2019-12-31")
      create(:allocation, project: project1, hourly_rate: 25, start_at: "2020-01-11", end_at: "2020-03-11")
      create(:allocation, project: project1, hourly_rate: 75, start_at: "2020-11-01", end_at: "2020-11-30")
      create(:allocation, project: project2, hourly_rate: 50, start_at: "2020-11-06", end_at: "2021-11-25")
      create(:allocation, project: project2, hourly_rate: 100, start_at: "2021-10-18", end_at: "2022-03-05")
      create(:allocation, start_at: "2021-01-01", end_at: "2021-12-31")
    end

    it "returns a hash containing the total forecast of the requested year considering only projects with allocations on the year" do
      expect(data).to eq([
                           {
                             project: project1,
                             forecast: {
                               1 => Money.new(300_000),
                               2 => Money.new(400_000),
                               3 => Money.new(160_000),
                               11 => Money.new(1_200_000)
                             }
                           },
                           {
                             project: project2,
                             forecast: {
                               11 => Money.new(680_000),
                               12 => Money.new(800_000)
                             }
                           }
                         ])
    end

    context 'when filter by market' do
      let(:data) { described_class.year_forecast(2020, :international) }

      it "returns a hash containing the total forecast of the requested year considering only projects of that market" do
        expect(data).to eq([
                             {
                               project: project2,
                               forecast: {
                                 11 => Money.new(680_000),
                                 12 => Money.new(800_000)
                               }
                             }
                           ])
      end
    end
  end

  describe ".detailed_month_forecast" do
    let!(:allocation1) { create(:allocation, start_at: '01/01/2024', end_at: '31/01/2024', hourly_rate: Money.new(1000)) }
    let!(:allocation2) { create(:allocation, start_at: '05/12/2023', end_at: '05/01/2024', hourly_rate: Money.new(1000)) }
    let!(:allocation3) { create(:allocation, start_at: '01/12/2023', end_at: '01/03/2024', hourly_rate: Money.new(1000)) }
    let!(:allocation4) { create(:allocation, start_at: '05/01/2024', end_at: '15/02/2024', hourly_rate: Money.new(1000)) }

    let(:data) { described_class.detailed_month_forecast(1, 2024) }

    it 'returns an array of hashes containing each allocation of the current month' do
      expect(data).to eq([
                           { user: allocation1.user.name, project: allocation1.project.name, hourly_rate: 'R$10,00', start_date: '01/01/2024', end_date: '31/01/2024', worked_hours: 184, total_revenue: "R$1.840,00" },
                           { user: allocation2.user.name, project: allocation2.project.name, hourly_rate: 'R$10,00', start_date: '01/01/2024', end_date: '05/01/2024', worked_hours: 40, total_revenue: 'R$400,00' },
                           { user: allocation3.user.name, project: allocation3.project.name, hourly_rate: 'R$10,00', start_date: '01/01/2024', end_date: '31/01/2024', worked_hours: 184, total_revenue: 'R$1.840,00' },
                           { user: allocation4.user.name, project: allocation4.project.name, hourly_rate: 'R$10,00', start_date: '05/01/2024', end_date: '31/01/2024', worked_hours: 152, total_revenue: 'R$1.520,00' }
                         ])
    end
  end
end
