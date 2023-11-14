# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContributionsSpreadsheet do
  let(:contribution) { create(:contribution) }
  let(:contribution_spreadsheet) { ContributionsSpreadsheet.new([contribution]) }
  let(:header_attributes) do
    %w[
      authors
      link
      created_at
      state
      pr_state
      reviewed_by
      reviewed_at
      rejected_reason
      updated_at
    ].map { |attribute| Contribution.human_attribute_name(attribute) }
  end

  let(:body_attributes) do
    [
      contribution.users.map(&:name).join(', '),
      contribution.link,
      contribution.created_at.to_s,
      Contribution.human_attribute_name("state/#{contribution.state}"),
      contribution.pr_state,
      contribution.reviewed_by,
      contribution.reviewed_at.to_s,
      contribution.rejected_reason_text,
      contribution.updated_at.to_s
    ]
  end

  describe '#to_string_io' do
    subject do
      contribution_spreadsheet
        .to_string_io
        .force_encoding('iso-8859-1')
        .encode('utf-8')
    end

    it 'returns spreadsheet data' do
      expect(contribution_spreadsheet).to receive(:generate_xlsx).once

      subject
    end
  end

  describe '#generate_xlsx' do
    subject(:spreadsheet) { contribution_spreadsheet.generate_xlsx }

    it 'returns spreadsheet object with header' do
      expect(spreadsheet.rows.first.cells.map(&:value)).to containing_exactly(*header_attributes)
    end

    it 'returns spreadsheet object with body' do
      expect(spreadsheet.rows.last.cells.map(&:value)).to containing_exactly(*body_attributes)
    end
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
