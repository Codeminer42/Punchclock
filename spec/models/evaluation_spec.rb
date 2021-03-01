# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  before { allow(subject).to receive(:english?).and_return(false) }

  describe 'Associations' do
    it { is_expected.to belong_to(:evaluated) }
    it { is_expected.to belong_to(:evaluator) }
    it { is_expected.to belong_to(:questionnaire) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:evaluated) }
    it { is_expected.to validate_presence_of(:evaluator) }
    it { is_expected.to validate_presence_of(:questionnaire) }
    it { is_expected.to validate_presence_of(:score) }
    it { is_expected.to validate_presence_of(:evaluation_date) }
    it { is_expected.to validate_inclusion_of(:score).in_array (1..10).to_a }
    it { is_expected.to enumerize(:english_level).in( beginner: 0,
                                                      intermediate: 1,
                                                      advanced: 2,
                                                      fluent: 3) }

    context 'when english kind' do
      before { allow(subject).to receive(:english?).and_return(true) }

      it { is_expected.to validate_presence_of(:english_level) }
    end

    context 'when not english kind' do
      it { is_expected.not_to validate_presence_of(:english_level) }
    end
  end

  describe 'Scopes' do
    context '#by_kind' do
      let!(:evaluation) { create(:evaluation) }
      let!(:english_evaluation) { create(:evaluation, :english) }

      it 'returns all english evaluations' do
        expect(Evaluation.by_kind(:english)).not_to include(evaluation)
        expect(Evaluation.by_kind(:english)).to include(english_evaluation)
      end

      it 'returns all performance evaluations' do
        expect(Evaluation.by_kind(:performance)).to include(evaluation)
        expect(Evaluation.by_kind(:performance)).not_to include(english_evaluation)
      end
    end
  end

  describe '#score_range' do
    it 'returns the score options range' do
      expect(Evaluation::SCORE_RANGE).to eq (1..10).to_a
    end
  end

  context 'When saving a new evaluation' do
    let(:evaluation) { build(:evaluation) }

    it 'updates evaluated office score' do
      expect(evaluation.evaluated.office).to receive(:calculate_score)

      evaluation.save
    end
  end
end
