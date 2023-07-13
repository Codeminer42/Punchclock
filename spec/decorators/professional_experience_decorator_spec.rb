# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfessionalExperienceDecorator do
  describe '#end_date' do
    subject { described_class.new(professional_experience).end_date }

    context 'when end_date is present' do
      let(:professional_experience) { build_stubbed(:professional_experience, end_date: '08/2022') }

      it { is_expected.to eq '08/2022' }
    end

    context 'when end_date is nil' do
      let(:professional_experience) { build_stubbed(:professional_experience, end_date: nil) }

      it { is_expected.to eq 'Presente' }
    end
  end

  describe '#start_date_month' do
    subject { described_class.new(professional_experience).start_date_month }

    let(:professional_experience) { build_stubbed(:professional_experience, start_date: '08/2022') }

    it { is_expected.to eq 'ago/2022' }
  end

  describe '#end_date_month' do
    subject { described_class.new(professional_experience).end_date_month }

    context 'when end_date is present' do
      let(:professional_experience) { build_stubbed(:professional_experience, end_date: '08/2022') }

      it { is_expected.to eq 'ago/2022' }
    end

    context 'when end_date is nil' do
      let(:professional_experience) { build_stubbed(:professional_experience, end_date: nil) }

      it { is_expected.to eq 'Presente' }
    end
  end
end
