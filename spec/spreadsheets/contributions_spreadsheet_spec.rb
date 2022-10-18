# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContributionsSpreadsheet do
  let(:contribution) { create(:contribution) }
  let(:contribution_spreadsheet) { ContributionsSpreadsheet.new([contribution]) }
  let(:header_attributes) do
    %w[
      user
      link
      state
      created_at
      updated_at
    ].map { |attribute| Contribution.human_attribute_name(attribute) }
  end

  let(:body_attributes) do
    [
      contribution.user.name,
      contribution.link,
      Contribution.human_attribute_name("state/#{contribution.state}"),
      I18n.l(contribution.created_at, format: :long),
      I18n.l(contribution.updated_at, format: :long)
    ]
  end

  describe '#to_string_io' do
    subject(:to_string_io) do
      contribution_spreadsheet.to_string_io
    end

    before do
      File.open('/tmp/spreadsheet_temp.xlsx', 'wb') {|f| f.write(subject) }
    end

    it_behaves_like 'a valid spreadsheet'
    it_behaves_like 'a spreadsheet with header and body'
  end

  describe '#body' do
    subject(:body) { contribution_spreadsheet.body(contribution) }

    it 'return body data' do
      expect(body).to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject(:header) { contribution_spreadsheet.header }

    it 'returns header data' do
      expect(header).to containing_exactly(*header_attributes)
    end
  end
end
