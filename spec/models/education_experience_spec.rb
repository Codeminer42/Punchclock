# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EducationExperience, type: :model do
  it { is_expected.to belong_to(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :institution }
    it { is_expected.to validate_presence_of :course }
    it { is_expected.to validate_presence_of :start_date }

    context 'when end_date is greater than start_date' do
      subject(:education_experience) do
        build(:education_experience, start_date: 4.years.ago, end_date: 2.months.ago)
      end

      it { is_expected.to be_valid }
    end

    context 'when start_date is greater than end_date' do
      subject(:education_experience) do
        build(:education_experience, start_date: 1.week.from_now, end_date: 8.years.ago)
      end

      it { is_expected.to_not be_valid }
    end

    context 'when start_date is today' do
      let(:education_experience) { build(:education_experience, start_date: Date.current) }

      it { expect(education_experience).to_not be_valid }
    end

    context 'when start_date is in the future' do
      let(:education_experience) { build(:education_experience, start_date: 1.day.from_now) }

      it { expect(education_experience).to_not be_valid }
    end
  end

  describe '.for_user' do
    let!(:user) { create(:user) }
    let!(:user_education_experience) { create(:education_experience, user:) }
    let!(:non_user_education_experience) { create(:education_experience) }

    it 'returns education experiences associated with the specified user' do
      expect(EducationExperience.for_user(user.id)).to include(user_education_experience)
    end

    it 'does not return education experiences associated with other users' do
      expect(EducationExperience.for_user(user.id)).not_to include(non_user_education_experience)
    end
  end
end
