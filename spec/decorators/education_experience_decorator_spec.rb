# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EducationExperienceDecorator do
  describe '#start_date' do
    subject { described_class.new(education_experience).start_date }

    let(:education_experience) { build_stubbed(:education_experience, start_date: DateTime.parse('2022-08-26T16:50')) }

    it { is_expected.to eq '26/08/2022' }
  end

  describe '#end_date' do
    subject { described_class.new(education_experience).end_date }

    let(:education_experience) { build_stubbed(:education_experience, end_date: DateTime.parse('2022-08-26T16:50')) }

    it { is_expected.to eq '26/08/2022' }
  end

  describe '#start_year' do
    subject { described_class.new(education_experience).start_year }

    let(:education_experience) { build_stubbed(:education_experience, start_date: DateTime.parse('2022-08-26T16:50')) }

    it { is_expected.to eq 2022 }
  end

  describe '#end_year' do
    subject { described_class.new(education_experience).end_year }

    let(:education_experience) { build_stubbed(:education_experience, end_date: DateTime.parse('2022-08-26T16:50')) }

    it { is_expected.to eq 2022 }
  end
end
