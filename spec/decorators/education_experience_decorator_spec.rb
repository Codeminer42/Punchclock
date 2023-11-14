# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EducationExperienceDecorator do
  subject { described_class.new(education_experience) }

  describe '#start_date' do
    let(:education_experience) { build_stubbed(:education_experience, start_date: DateTime.parse('2022-08-26T16:50')) }

    it 'returns the start date' do
      expect(subject.start_date).to eq('26/08/2022')
    end
  end

  describe '#end_date' do
    context 'when end date exist' do
      let(:education_experience) { build_stubbed(:education_experience, end_date: DateTime.parse('2022-08-26T16:50')) }

      it 'returns the end date' do
        expect(subject.end_date).to eq('26/08/2022')
      end
    end

    context 'when end date does not exist' do
      let(:education_experience) { build_stubbed(:education_experience, end_date: nil) }

      it 'returns the end date' do
        expect(subject.end_date).to eq('-')
      end
    end
  end

  describe '#start_year' do
    let(:education_experience) { build_stubbed(:education_experience, start_date: DateTime.parse('2022-08-26T16:50')) }

    it 'returns the start year' do
      expect(subject.start_year).to eq(2022)
    end
  end

  describe '#end_year' do
    context 'when end date exist' do
      let(:education_experience) { build_stubbed(:education_experience, end_date: DateTime.parse('2022-08-26T16:50')) }

      it 'returns the end year' do
        expect(subject.end_year).to eq(2022)
      end
    end

    context 'when end date does not exist' do
      let(:education_experience) { build_stubbed(:education_experience, end_date: nil) }

      it 'does not return the end year' do
        expect(subject.end_year).to eq('-')
      end
    end
  end
end
