require 'rails_helper'

RSpec.describe RevenueForecastService do
  describe ".allocation_forecast" do
    let(:allocation) { build_stubbed(:allocation, hourly_rate: 100, start_at: "2021-10-18", end_at: "2022-03-05") }
    let(:data) { described_class.allocation_forecast(allocation) }

    it "returns a hash containing the total working days and forecast for each month of the allocation" do
      expect(data).to eq([
        { month: 10, year: 2021, working_hours: 80, forecast: Money.new(8000_00) },
        { month: 11, year: 2021, working_hours: 160, forecast: Money.new(16000_00) },
        { month: 12, year: 2021, working_hours: 160, forecast: Money.new(16000_00) },
        { month: 1, year: 2022, working_hours: 160, forecast: Money.new(16000_00) },
        { month: 2, year: 2022, working_hours: 160, forecast: Money.new(16000_00) },
        { month: 3, year: 2022, working_hours: 32, forecast: Money.new(3200_00) }
      ])
    end

    context 'when allocation currency is USD' do
      let(:allocation) do
        build_stubbed(:allocation, hourly_rate: Money.new(100_00, 'USD'), start_at: "2021-10-18", end_at: "2022-03-05")
      end

      before do
        travel_to(Date.new(2022, 01, 15))

        create(:exchange_rate, month: 9, year: 2021, rate: 5.15)
        create(:exchange_rate, month: 10, year: 2021, rate: 5.2)
        create(:exchange_rate, month: 11, year: 2021, rate: 5.25)
        create(:exchange_rate, month: 12, year: 2021, rate: 5.3)
      end

      after { travel_back }

      it "returns the forecasts converted to BRL" do
        expect(data).to eq([
          { month: 10, year: 2021, working_hours: 80, forecast: Money.new(41200_00, 'BRL') },
          { month: 11, year: 2021, working_hours: 160, forecast: Money.new(83200_00, 'BRL') },
          { month: 12, year: 2021, working_hours: 160, forecast: Money.new(84000_00, 'BRL') },
          { month: 1, year: 2022, working_hours: 160, forecast: Money.new(84800_00, 'BRL') },
          { month: 2, year: 2022, working_hours: 160, forecast: Money.new(84800_00, 'BRL') },
          { month: 3, year: 2022, working_hours: 32, forecast: Money.new(16960_00, 'BRL') }
        ])
      end

      context "there's no exchange rate for a month" do
        let(:allocation) do
          build_stubbed(:allocation, hourly_rate: Money.new(100_00, 'USD'), start_at: "2021-01-01", end_at: "2021-03-30")
        end

        it "raises an exception saying that the exchange rate is missing" do
          expect { data }.to raise_exception(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when allocation starts and ends in the same month' do
      let(:allocation) { build_stubbed(:allocation, hourly_rate: 100, start_at: "2022-10-04", end_at: "2022-10-17") }

      it "returns a hash containing the total working days and forecast for the single month of allocation" do
        expect(data).to eq([
          { month: 10, year: 2022, working_hours: 80, forecast: Money.new(8000_00) }
        ])
      end
    end
  end

  describe ".project_forecast" do
    let(:project) { create(:project) }
    let(:data) { described_class.project_forecast(project) }

    before do
      create(:allocation, hourly_rate: 15, start_at: "2020-01-11", end_at: "2020-03-11")
      create(:allocation, project: project, hourly_rate: 25, start_at: "2020-01-11", end_at: "2020-03-11")
      create(:allocation, project: project, hourly_rate: 50, start_at: "2020-11-06", end_at: "2021-11-25")
      create(:allocation, project: project, hourly_rate: 100, start_at: "2021-10-18", end_at: "2022-03-05")
      create(:allocation, hourly_rate: 150, start_at: "2021-10-18", end_at: "2022-03-05")
    end

    it "returns a hash containing the total forecasts for all project's allocations separated by year and month" do
      expect(data).to eq({
        2020 => {
          1 => Money.new(3000_00),
          2 => Money.new(4000_00),
          3 => Money.new(1600_00),
          11 => Money.new(6800_00),
          12 => Money.new(8000_00)
        },
        2021 => {
          1 => Money.new(8000_00),
          2 => Money.new(8000_00),
          3 => Money.new(8000_00),
          4 => Money.new(8000_00),
          5 => Money.new(8000_00),
          6 => Money.new(8000_00),
          7 => Money.new(8000_00),
          8 => Money.new(8000_00),
          9 => Money.new(8000_00),
          10 => Money.new(8000_00 + 8000_00),
          11 => Money.new(7600_00 + 16000_00),
          12 => Money.new(16000_00)
        },
        2022 => {
          1 => Money.new(16000_00),
          2 => Money.new(16000_00),
          3 => Money.new(3200_00)
        }
      })
    end
  end

  describe ".year_forecast" do
    let(:project1) { create(:project, :inactive) }
    let(:project2) { create(:project) }
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
            1 => Money.new(3000_00),
            2 => Money.new(4000_00),
            3 => Money.new(1600_00),
            11 => Money.new(12000_00)
          }
        },
        {
          project: project2,
          forecast: {
            11 => Money.new(6800_00),
            12 => Money.new(8000_00)
          }
        }
      ])
    end
  end
end
