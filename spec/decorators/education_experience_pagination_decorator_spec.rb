# frozen_string_literal: true

RSpec.describe EducationExperiencePaginationDecorator do
  subject { EducationExperiencePaginationDecorator.new(params, education_experiences) }

  describe '#start_date' do
    let!(:experience) { create_list(:education_experience, 3, start_date: DateTime.new(2022, 8, 26), end_date: DateTime.new(2023, 8, 26)) }

    let(:params) { { page: 1, per: 2 } }
    let(:education_experiences) { EducationExperience.all }

    it 'returns the start date' do
      expect(subject.first.decorate.start_date).to eq('26/08/2022')
    end
  end

  describe '#end_date' do
    context 'when end date exist' do
      let!(:experience) { create_list(:education_experience, 3, start_date: DateTime.new(2022, 8, 26), end_date: DateTime.new(2023, 8, 26)) }

      let(:params) { { page: 1, per: 2 } }
      let(:education_experiences) { EducationExperience.all }

      it 'returns the end date' do
        expect(subject.first.decorate.end_date).to eq('26/08/2023')
      end
    end

    context 'when end date does not exist' do
      let!(:experience) { create_list(:education_experience, 3, start_date: DateTime.new(2022, 8, 26), end_date: nil) }

      let(:params) { { page: 1, per: 2 } }
      let(:education_experiences) { EducationExperience.all }

      it 'does not return a date' do
        expect(subject.decorate.first.end_date).to eq('-')
      end
    end
  end

  describe '#start_year' do
    let!(:experience) { create_list(:education_experience, 3, start_date: DateTime.new(2022, 8, 26), end_date: DateTime.new(2023, 8, 26)) }

    let(:params) { { page: 1, per: 2 } }
    let(:education_experiences) { EducationExperience.all }

    it 'returns the start year' do
      expect(subject.first.decorate.start_year).to eq(2022)
    end
  end

  describe '#end_year' do
    context 'when end date exist' do
      let!(:experience) { create_list(:education_experience, 3, start_date: DateTime.new(2022, 8, 26), end_date: DateTime.new(2023, 8, 26)) }

      let(:params) { { page: 1, per: 2 } }
      let(:education_experiences) { EducationExperience.all }

      it 'returns the end year' do
        expect(subject.first.decorate.end_year).to eq(2023)
      end
    end

    context 'when end date does not exist' do
      let!(:experience) { create_list(:education_experience, 3, start_date: DateTime.new(2022, 8, 26), end_date: nil) }

      let(:params) { { page: 1, per: 2 } }
      let(:education_experiences) { EducationExperience.all }

      it 'it does not return a year' do
        expect(subject.first.decorate.end_year).to eq('-')
      end
    end
  end
end
