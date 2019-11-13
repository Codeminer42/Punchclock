# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionnairesSpreadsheet do
  let(:questionnaire) { create(:questionnaire) }
  let(:questionnaire_spreadsheet) { QuestionnairesSpreadsheet.new([questionnaire]) }
  let(:header_attributes) do
    [
      Questionnaire.human_attribute_name('id'),
      Questionnaire.human_attribute_name('title'),
      Questionnaire.human_attribute_name('kind'),
      Questionnaire.human_attribute_name('description'),
      Questionnaire.human_attribute_name('active'),
      Questionnaire.human_attribute_name('created_at'),
      Questionnaire.human_attribute_name('updated_at')
    ]
  end

  let (:body_attributes) do
    [
      questionnaire.id,
      questionnaire.title,
      questionnaire.kind,
      questionnaire.description,
      questionnaire.active,
      I18n.l(questionnaire.created_at, format: :long),
      I18n.l(questionnaire.updated_at, format: :long),
    ]
  end

  describe '#to_string_io' do
    subject do
      questionnaire_spreadsheet
        .to_string_io
        .force_encoding('iso-8859-1')
        .encode('utf-8')
    end

    it 'returns spreadsheet data' do
      is_expected.to include(
                             questionnaire.title,
                             questionnaire.kind,
                             questionnaire.description
                             )
    end

    it 'returns spreadsheet with header' do
      is_expected.to include(*header_attributes)
    end
  end

  describe '#generate_xls' do
    subject(:spreadsheet) { questionnaire_spreadsheet.generate_xls }

    it 'returns spreadsheet object with header' do
      expect(spreadsheet.row(0)).to containing_exactly(*header_attributes)
    end

    it 'returns spreadsheet object with body' do
      expect(spreadsheet.row(1)).to containing_exactly(*body_attributes)
    end
  end

  describe '#body' do
    subject { questionnaire_spreadsheet.body(questionnaire) }

    it 'return body data' do
      is_expected.to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject { questionnaire_spreadsheet.header }

    it 'returns header data' do
      is_expected.to containing_exactly(*header_attributes)
    end
  end
end
