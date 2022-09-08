# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RevenueForecastPresenter do
  subject { described_class.new(year) }

  let(:year) { rand(2011..2022) }
  let(:project1) { build_stubbed(:project) }
  let(:project2) { build_stubbed(:project) }

  let(:data) do
    [{
      project: project1,
      revenue: {
        1 => Money.new(300000),
        2 => Money.new(400000),
        3 => Money.new(160000),
        11 => Money.new(1260000)
      }
    },
    {
      project: project2,
      revenue: {
        11 => Money.new(680000),
        12 => Money.new(920000)
      }
    }]
  end

  before do
    allow(RevenueProjectorService).to receive(:revenue_from_year)
      .with(year)
      .and_return(data)
  end

  context '#projects' do
    it 'returns an array with the projects with revenue' do
      expect(subject.projects).to eq([project1, project2])
    end
  end

  context '#months' do
    it 'calls the provided block providing the month name and the revenues of each month' do
      args = [
        ["January", ["R$3.000", "-"], "R$3.000"],
        ["February", ["R$4.000", "-"], "R$4.000"],
        ["March", ["R$1.600", "-"], "R$1.600"],
        ["April", ["-", "-"], "R$0"],
        ["May", ["-", "-"], "R$0"],
        ["June", ["-", "-"], "R$0"],
        ["July", ["-", "-"], "R$0"],
        ["August", ["-", "-"], "R$0"],
        ["September", ["-", "-"], "R$0"],
        ["October", ["-", "-"], "R$0"],
        ["November", ["R$12.600", "R$6.800"], "R$19.400"],
        ["December", ["-", "R$9.200"], "R$9.200"]
      ]

      expect { |b| subject.months(&b) }.to yield_successive_args(*args)
    end
  end

  context '.years_range' do
    it 'returns a range where the first year is the year when the oldest allocation started
      and the last year is the year when the last allocation ends' do
      create(:allocation, start_at: "2014-10-18", end_at: "2016-10-18")
      create(:allocation, start_at: "2018-02-10", end_at: "2020-03-14")
      expect(described_class.years_range).to eq((2014..2020))

      create(:allocation, start_at: "1894-02-01", end_at: "1895-02-01")
      expect(described_class.years_range).to eq((1894..2020))

      create(:allocation, end_at: "2025-02-01")
      expect(described_class.years_range).to eq((1894..2025))
    end
  end
end
