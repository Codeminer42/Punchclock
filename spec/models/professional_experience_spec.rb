# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfessionalExperience, type: :model do
  it { is_expected.to belong_to(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :company }
    it { is_expected.to validate_presence_of :position }
    it { is_expected.to validate_presence_of :start_date }

    context 'when end_date is greater than start_date' do
      subject(:professional_experience) do
        build(:professional_experience, start_date: '01/2019', end_date: '01/2023')
      end

      it { is_expected.to be_valid }
    end

    context 'when start_date is greater than end_date' do
      subject(:professional_experience) do
        build(:professional_experience, start_date: '01/2023', end_date: '01/2019')
      end

      it { is_expected.to_not be_valid }
    end

    context 'when start_date is in the future' do
      let(:professional_experience) { build(:professional_experience, start_date: "10/#{Date.current.year + 1}") }

      it { expect(professional_experience).to_not be_valid }
    end

    context 'when start_date is in the current month' do
      let(:professional_experience) { build(:professional_experience, start_date: Date.current.strftime('%m/%Y'), end_date: nil) }

      it { expect(professional_experience).to be_valid }
    end

    context 'when start_date format is invalid' do
      let(:professional_experience) { build(:professional_experience, start_date: '10/1') }

      it { expect(professional_experience).to_not be_valid }
    end

    context 'when end_date format is invalid' do
      let(:professional_experience) { build(:professional_experience, end_date: 'invalid') }

      it { expect(professional_experience).to_not be_valid }
    end
  end

  describe '#ordered_by_start_date' do
    let!(:user) { create(:user) }
    let!(:old_experience) { create(:professional_experience, start_date: '06/2014', end_date: '01/2015', user:) }
    let!(:older_experience) { create(:professional_experience, start_date: '04/2012', end_date: '03/2016', user:) }
    let!(:current_experience) { create(:professional_experience, start_date: "05/#{Date.current.year}", end_date: nil, user:) }

    subject { user.professional_experiences.ordered_by_start_date }

    it { is_expected.to eq [older_experience, old_experience, current_experience] }
  end

  describe 'scopes' do
    describe 'by_user' do
      let!(:user) { create(:user) }
      let!(:user_experience) { create(:professional_experience, user:) }
      let!(:other_experience) { create(:professional_experience) }

      it "returns only the user's professional experience" do
        expect(ProfessionalExperience.by_user(user.id)).to eq([user_experience])
      end
    end
  end
end
