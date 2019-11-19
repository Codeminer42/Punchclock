# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompaniesSpreadsheet do
  let(:company) { create(:company) }
  let(:company_spreadsheet) { CompaniesSpreadsheet.new([company]) }
  let(:header_attributes) do
    %w[
      name
      created_at
      updated_at
    ].map { |attribute| Company.human_attribute_name(attribute) }
  end

  let (:body_attributes) do
    [
      company.name,
      I18n.l(company.created_at, format: :long),
      I18n.l(company.created_at, format: :long)
    ]
  end

  describe '#to_string_io' do
    subject(:to_string_io) do
      company_spreadsheet
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
    subject(:spreadsheet) { company_spreadsheet.generate_xls }

    it 'returns spreadsheet object with header' do
      expect(spreadsheet.row(0)).to containing_exactly(*header_attributes)
    end

    it 'returns spreadsheet object with body' do
      expect(spreadsheet.row(1)).to containing_exactly(*body_attributes)
    end
  end

  describe '#body' do
    subject(:body) { company_spreadsheet.body(company) }

    it 'return body data' do
      expect(body).to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject(:header) { company_spreadsheet.header }

    it 'returns header data' do
      expect(header).to containing_exactly(*header_attributes)
    end
  end
end
