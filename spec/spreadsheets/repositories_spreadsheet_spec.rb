# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepositoriesSpreadsheet do
  let(:repository) { create(:repository) }
  let(:repository_spreadsheet) { RepositoriesSpreadsheet.new([repository]) }
  let(:header_attributes) do
    %w[
      link
      created_at
      updated_at
    ].map { |attribute| Repository.human_attribute_name(attribute) }
  end

  let(:body_attributes) do
    [
      repository.link,
      I18n.l(repository.created_at, format: :long),
      I18n.l(repository.updated_at, format: :long)
    ]
  end

  describe '#to_string_io' do
    subject(:to_string_io) do
      repository_spreadsheet.to_string_io
    end

    before do
      File.open('/tmp/spreadsheet_temp.xlsx', 'wb') {|f| f.write(subject) }
    end

    it_behaves_like 'a valid spreadsheet'
    it_behaves_like 'a spreadsheet with header and body'
  end

  describe '#body' do
    subject(:body) { repository_spreadsheet.body(repository) }

    it 'return body data' do
      expect(body).to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject(:header) { repository_spreadsheet.header }

    it 'returns header data' do
      expect(header).to containing_exactly(*header_attributes)
    end
  end
end
