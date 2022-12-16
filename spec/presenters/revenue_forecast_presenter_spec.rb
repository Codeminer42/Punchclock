# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RevenueForecastPresenter do
  subject { described_class.new(year, market) }

  let(:year) { rand(2011..2022) }
  let(:market) { double(:market) }
  let(:project1) { build_stubbed(:project, name: 'Argentina') }
  let(:project2) { build_stubbed(:project, name: 'Zimbabwe') }

  let(:data) do
    [{
      project: project2,
      forecast: {
        11 => Money.new(6800_00),
        12 => Money.new(9200_00)
      }
    },
    {
      project: project1,
      forecast: {
        1 => Money.new(3000_00),
        2 => Money.new(4000_00),
        3 => Money.new(1600_00),
        11 => Money.new(12600_00)
      }
    }]
  end

  before do
    allow(RevenueForecastService).to receive(:year_forecast)
      .with(year, market)
      .and_return(data)
  end

  context '#projects' do
    it 'returns an array with the projects with projected revenue ordered by name' do
      expect(subject.projects).to eq([project1, project2])
    end
  end

  context '#months' do
    it 'calls the provided block providing the month name and the forecast of each month' do
      args = [
        ["January", ["R$3.000,00", "-"], "R$3.000,00"],
        ["February", ["R$4.000,00", "-"], "R$4.000,00"],
        ["March", ["R$1.600,00", "-"], "R$1.600,00"],
        ["April", ["-", "-"], "R$0,00"],
        ["May", ["-", "-"], "R$0,00"],
        ["June", ["-", "-"], "R$0,00"],
        ["July", ["-", "-"], "R$0,00"],
        ["August", ["-", "-"], "R$0,00"],
        ["September", ["-", "-"], "R$0,00"],
        ["October", ["-", "-"], "R$0,00"],
        ["November", ["R$12.600,00", "R$6.800,00"], "R$19.400,00"],
        ["December", ["-", "R$9.200,00"], "R$9.200,00"]
      ]

      expect { |b| subject.months(&b) }.to yield_successive_args(*args)
    end
  end

  context '.years_range' do
    it 'returns a range where the first year is 2022
      and the last year is the year when the last allocation ends' do
      create(:allocation, start_at: "2018-02-10", end_at: "2025-03-14")
      expect(described_class.years_range).to eq((2022..2025))

      create(:allocation, start_at: "1894-02-01", end_at: "1895-02-01")
      expect(described_class.years_range).to eq((2022..2025))

      create(:allocation, end_at: "2027-02-01")
      expect(described_class.years_range).to eq((2022..2027))
    end
  end
end
