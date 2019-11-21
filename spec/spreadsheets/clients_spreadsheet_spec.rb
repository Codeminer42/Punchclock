# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientsSpreadsheet do
  let(:client) { create(:client) }
  let(:client_spreadsheet) { ClientsSpreadsheet.new([client]) }
  let(:header_attributes) do
    %w[
      name
      active
      created_at
      updated_at
    ].map { |attribute| Client.human_attribute_name(attribute) }
  end

  let(:body_attributes) do
    [
      client.name,
      I18n.t(client.active.to_s),
      I18n.l(client.created_at, format: :long),
      I18n.l(client.updated_at, format: :long)
    ]
  end

  describe '#to_string_io' do
    subject(:to_string_io) do
      client_spreadsheet
        .to_string_io
        .force_encoding('iso-8859-1')
        .encode('utf-8')
    end

    it 'returns spreadsheet data' do
      expect(to_string_io).to include(client.name,
                                      I18n.t(client.active.to_s),
                                      I18n.l(client.created_at, format: :long),
                                      I18n.l(client.updated_at, format: :long))
    end

    it 'returns spreadsheet with header' do
      expect(to_string_io).to include(*header_attributes)
    end
  end

  describe '#body' do
    subject(:body) { client_spreadsheet.body(client) }

    it 'returns body data' do
      expect(body).to containing_exactly(*body_attributes)
    end
  end

  describe '#generate_xls' do
    subject(:spreadsheet) { client_spreadsheet.generate_xls }

    it 'returns spreadsheet object with header' do
      expect(spreadsheet.row(0)).to containing_exactly(*header_attributes)
    end

    it 'returns spreadsheet object with body' do
      expect(spreadsheet.row(1)).to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject(:header) { client_spreadsheet.header }

    it 'returns header data' do
      expect(header).to containing_exactly(*header_attributes)
    end
  end
end
