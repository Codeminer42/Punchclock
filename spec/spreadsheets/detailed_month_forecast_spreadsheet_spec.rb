require 'rails_helper'

RSpec.describe DetailedMonthForecastSpreadsheet do
  let!(:user) { create(:user) }
  let!(:project) { create(:project) }
  let!(:allocation) { create(:allocation, user:, project:, start_at: '01/01/2023', end_at: '31/01/2023') }
  let!(:detailed_allocation_info) { RevenueForecastService.detailed_month_forecast(1, 2023) }

  let(:detailed_forecast_spreadsheet) { DetailedMonthForecastSpreadsheet.new(detailed_allocation_info) }
  let(:header_attributes) do
    [
      Allocation.human_attribute_name('user'),
      Allocation.human_attribute_name('project'),
      Allocation.human_attribute_name('hourly_rate'),
      Allocation.human_attribute_name('start_at'),
      Allocation.human_attribute_name('end_at'),
      I18n.t('allocation.worked_hours'),
      I18n.t('allocation.total_revenue')
    ]
  end

  let(:body_attributes) do
    [
      detailed_allocation_info.first[:user],
      detailed_allocation_info.first[:project],
      detailed_allocation_info.first[:hourly_rate],
      detailed_allocation_info.first[:start_date],
      detailed_allocation_info.first[:end_date],
      detailed_allocation_info.first[:worked_hours],
      detailed_allocation_info.first[:total_revenue]
    ]
  end

  describe '#to_string_io' do
    subject do
      detailed_forecast_spreadsheet.to_string_io
    end

    before do
      File.open('/tmp/spreadsheet_temp.xlsx', 'wb') { |f| f.write(subject) }
    end

    it_behaves_like 'a valid spreadsheet'
    it_behaves_like 'a spreadsheet with header and body'
  end

  describe '#body' do
    subject { detailed_forecast_spreadsheet.body(detailed_allocation_info.first) }

    it 'returns body data' do
      is_expected.to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject { detailed_forecast_spreadsheet.header }

    it 'returns header data' do
      is_expected.to containing_exactly(*header_attributes)
    end
  end
end
