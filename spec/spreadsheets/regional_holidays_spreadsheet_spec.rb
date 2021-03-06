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

  let (:body_attributes) do
    [
      regional_holiday.name,
      regional_holiday.day.to_s,
      regional_holiday.month.to_s,
      I18n.l(regional_holiday.created_at, format: :long),
      I18n.l(regional_holiday.updated_at, format: :long)
    ]
  end

  describe '#to_string_io' do
    subject(:to_string_io) do
      regional_holiday_spreadsheet
        .to_string_io
        .force_encoding('iso-8859-1')
        .encode('utf-8')
    end

    it 'returns spreadsheet data' do
      expect(to_string_io).to include(*body_attributes)
    end

    it 'returns spreadsheet with header' do
      expect(to_string_io).to include(*header_attributes)
    end
  end

  describe '#generate_xls' do
    subject(:spreadsheet) { regional_holiday_spreadsheet.generate_xls }

    it 'returns spreadsheet object with header' do
      expect(spreadsheet.row(0)).to containing_exactly(*header_attributes)
    end

    it 'returns spreadsheet object with body' do
      expect(spreadsheet.row(1)).to containing_exactly(*body_attributes)
    end
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
