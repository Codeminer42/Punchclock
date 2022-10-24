# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OfficesSpreadsheet do
  let(:office) { create(:office) }
  let(:office_spreadsheet) { OfficesSpreadsheet.new([office]) }
  let(:header_attributes) do
    %w[
      city
      head
      users_quantity
      score
      created_at
      updated_at
    ].map { |attribute| Office.human_attribute_name(attribute) }
  end

  let(:body_attributes) do
    [
      office.city,
      office.head&.name,
      office.users.active.size,
      office.score,
      I18n.l(office.created_at, format: :long),
      I18n.l(office.created_at, format: :long)
    ]
  end

  describe '#to_string_io' do
    subject do
      office_spreadsheet.to_string_io
    end

    before do
      File.open('/tmp/spreadsheet_temp.xlsx', 'wb') {|f| f.write(subject) }
    end

    it_behaves_like 'a valid spreadsheet'
    it_behaves_like 'a spreadsheet with header and body'

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
