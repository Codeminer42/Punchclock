# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OfficesSpreadsheet do
  let(:office) { create(:office) }
  let(:office_spreadsheet) { OfficesSpreadsheet.new([office]) }
  let(:header_attributes) do
    %w[
      city
      company
      head
      users_quantity
      score
      created_at
      updated_at
    ].map { |attribute| Office.human_attribute_name(attribute) }
  end

  let (:body_attributes) do
    [
      office.city,
      office.company&.name,
      office.head&.name,
      office.users.active.size,
      office.score,
      I18n.l(office.created_at, format: :long),
      I18n.l(office.created_at, format: :long)
    ]
  end

  describe '#to_string_io' do
    subject(:to_string_io) do
      office_spreadsheet
        .to_string_io
        .force_encoding('iso-8859-1')
        .encode('utf-8')
    end

    it 'returns spreadsheet data' do
      expect(to_string_io).to include(
        office.city,
        office.company&.name,
        '0',
        I18n.l(office.created_at, format: :long),
        I18n.l(office.created_at, format: :long)
      )
    end

    it 'returns spreadsheet with header' do
      expect(to_string_io).to include(*header_attributes)
    end
  end

  describe '#generate_xls' do
    subject(:spreadsheet) { office_spreadsheet.generate_xls }

    it 'returns spreadsheet object with header' do
      expect(spreadsheet.row(0)).to containing_exactly(*header_attributes)
    end

    it 'returns spreadsheet object with body' do
      expect(spreadsheet.row(1)).to containing_exactly(*body_attributes)
    end
  end

  describe '#body' do
    subject(:body) { office_spreadsheet.body(office) }

    it 'return body data' do
      expect(body).to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject(:header) { office_spreadsheet.header }

    it 'returns header data' do
      expect(header).to containing_exactly(*header_attributes)
    end
  end
end
