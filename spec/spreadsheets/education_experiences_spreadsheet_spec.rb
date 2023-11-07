# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EducationExperiencesSpreadsheet do
  let(:education_experience) { create(:education_experience) }
  let(:education_experience_spreadsheet) { EducationExperiencesSpreadsheet.new([education_experience]) }
  let(:header_attributes) do
    %w[
      id
      user_id
      institution
      course
      start_date
      end_date
    ].map { |attribute| EducationExperience.human_attribute_name(attribute) }
  end

  let(:body_attributes) do
    [
      education_experience.id,
      education_experience.user_id,
      education_experience.institution,
      education_experience.course,
      education_experience.start_date,
      education_experience.end_date
    ]
  end

  describe '#to_string_io' do
    subject(:to_string_io) do
      education_experience_spreadsheet.to_string_io
    end

    before do
      File.open('/tmp/spreadsheet_temp.xlsx', 'wb') {|f| f.write(subject) }
    end

    it_behaves_like 'a valid spreadsheet'
    it_behaves_like 'a spreadsheet with header and body'
  end

  describe '#body' do
    subject(:body) { education_experience_spreadsheet.body(education_experience) }

    it 'return body data' do
      expect(body).to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject(:header) { education_experience_spreadsheet.header }

    it 'returns header data' do
      expect(header).to containing_exactly(*header_attributes)
    end
  end
end
