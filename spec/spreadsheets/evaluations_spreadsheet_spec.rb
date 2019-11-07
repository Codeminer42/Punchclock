# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EvaluationsSpreadsheet do
  let(:evaluation) { create(:evaluation) }
  let(:evaluation_spreadsheet) { EvaluationsSpreadsheet.new([evaluation]) }
  let(:header_attributes) do
    [
      Evaluation.human_attribute_name('id'),
      Evaluation.human_attribute_name('observation'),
      Evaluation.human_attribute_name('score'),
      Evaluation.human_attribute_name('english_level'),
      Evaluation.human_attribute_name('created_at'),
      Evaluation.human_attribute_name('updated_at')
    ]
  end

  let (:body_attributes) do
    [
      evaluation.id,
      evaluation.observation,
      evaluation.score,
      evaluation.english_level,
      evaluation.created_at,
      evaluation.updated_at
    ]
  end

  describe '#to_string_io' do
    subject do
      evaluation_spreadsheet
        .to_string_io
        .force_encoding('iso-8859-1')
        .encode('utf-8')
    end

    it 'returns spreadsheet data' do
      is_expected.to include(
        evaluation.observation,
        evaluation.english_level.to_s
                             )
    end

    it 'returns spreadsheet with header' do
      is_expected.to include(*header_attributes)
    end
  end

  describe '#generate_xls' do
    subject(:spreadsheet) { evaluation_spreadsheet.generate_xls }

    it 'returns spreadsheet object with header' do
      expect(spreadsheet.row(0)).to containing_exactly(*header_attributes)
    end

    it 'returns spreadsheet object with body' do
      expect(spreadsheet.row(1)).to containing_exactly(*body_attributes)
    end
  end

  describe '#body' do
    subject { evaluation_spreadsheet.body(evaluation) }

    it 'return body data' do
      is_expected.to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject { evaluation_spreadsheet.header }

    it 'returns header data' do
      is_expected.to containing_exactly(*header_attributes)
    end
  end
end
