# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EvaluationDecorator do
  describe '#created_at' do
    subject { described_class.new(evaluation).created_at }

    let(:evaluation) { build_stubbed(:evaluation, created_at: Date.parse('2023-07-13')) }

    it { is_expected.to eq('13/07/2023') }
  end

  describe '#evaluation_date' do
    subject { described_class.new(evaluation).evaluation_date }

    let(:evaluation) { build_stubbed(:evaluation, evaluation_date: Date.parse('2023-12-13')) }

    it { is_expected.to eq('13/12/2023') }
  end
end
