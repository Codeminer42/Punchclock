# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegionalHolidaysSpreadsheet do
  let(:regional_holiday) { create(:regional_holiday) }
  let(:regional_holiday_spreadsheet) { RegionalHolidaysSpreadsheet.new([regional_holiday]) }
  let(:header_attributes) do
    %w[
      name
      day
      month
      created_at
      updated_at
    ].map { |attribute| RegionalHoliday.human_attribute_name(attribute) }
  end

  let(:body_attributes) do
    [
      regional_holiday.name,
      regional_holiday.day,
      regional_holiday.month,
      I18n.l(regional_holiday.created_at, format: :long),
      I18n.l(regional_holiday.updated_at, format: :long)
    ]
  end

  describe '#to_string_io' do
    subject(:to_string_io) do
      regional_holiday_spreadsheet.to_string_io
    end

    before do
      File.open('/tmp/spreadsheet_temp.xlsx', 'wb') {|f| f.write(subject) }
    end

    it_behaves_like 'a valid spreadsheet'
    it_behaves_like 'a spreadsheet with header and body'
  end

  describe '#body' do
    subject(:body) { regional_holiday_spreadsheet.body(regional_holiday) }

    it 'return body data' do
      expect(body).to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject(:header) { regional_holiday_spreadsheet.header }

    it 'returns header data' do
      expect(header).to containing_exactly(*header_attributes)
    end
  end
end
