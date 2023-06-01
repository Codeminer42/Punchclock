require 'rails_helper'

RSpec.describe ProfessionalExperience, type: :model do
  it { is_expected.to belong_to(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :company }
    it { is_expected.to validate_presence_of :position }
    it { is_expected.to validate_presence_of :start_date }

    context 'when end_date is greater than start_date' do
      subject(:professional_experience) do
        build(:professional_experience, start_date: 4.years.ago, end_date: 2.months.ago)
      end

      it { is_expected.to be_valid }
    end

    context 'when start_date is greater than end_date' do
      subject(:professional_experience) do
        build(:professional_experience, start_date: 1.week.from_now, end_date: 8.years.ago)
      end

      it { is_expected.to_not be_valid }
    end

    context 'when start_date is today' do
      let(:professional_experience) { build(:professional_experience, start_date: Date.current) }

      it { expect(professional_experience).to_not be_valid }
    end

    context 'when start_date is in the future' do
      let(:professional_experience) { build(:professional_experience, start_date: 1.day.from_now) }

      it { expect(professional_experience).to_not be_valid }
    end
  end
end
