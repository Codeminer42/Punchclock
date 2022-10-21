# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EvaluationsSpreadsheet do
  let(:evaluation) { create(:evaluation, :english) }
  let(:evaluation_spreadsheet) { EvaluationsSpreadsheet.new([evaluation]) }
  let(:header_attributes) do
    [
      Evaluation.human_attribute_name('id'),
      Evaluation.human_attribute_name('evaluator'),
      Evaluation.human_attribute_name('evaluated'),
      Evaluation.human_attribute_name('evaluated_email'),
      Evaluation.human_attribute_name('observation'),
      Evaluation.human_attribute_name('score'),
      Evaluation.human_attribute_name('english_level'),
      Evaluation.human_attribute_name('questionnaire'),
      Evaluation.human_attribute_name('questionnaire_kind'),
      Evaluation.human_attribute_name('created_at'),
      Evaluation.human_attribute_name('updated_at'),
      Evaluation.human_attribute_name('evaluation_date')
    ]
  end

  let(:body_attributes) do
    [
      evaluation.id,
      evaluation.evaluator.name,
      evaluation.evaluated.name,
      evaluation.evaluated.email,
      evaluation.observation,
      evaluation.score,
      evaluation.english_level.text,
      evaluation.questionnaire.title,
      evaluation.questionnaire.kind,
      I18n.l(evaluation.created_at, format: :long),
      I18n.l(evaluation.updated_at, format: :long),
      I18n.l(evaluation.evaluation_date, format: :long)
    ]
  end

  describe '#to_string_io' do
    subject do
      evaluation_spreadsheet.to_string_io
    end

    before do
      File.open('/tmp/spreadsheet_temp.xlsx', 'wb') {|f| f.write(subject) }
    end

    it_behaves_like 'a valid spreadsheet'
    it_behaves_like 'a spreadsheet with header and body'
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
