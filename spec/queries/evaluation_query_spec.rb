# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EvaluationQuery do
  subject(:call) { described_class.new(**options).call }

  describe '#call' do
    let(:alice) { create(:user, :active_user) }
    let(:bob)   { create(:user, :active_user) }

    let!(:english_evaluation) do
      create(
        :evaluation,
        :english,
        evaluator: bob,
        evaluated: alice,
        evaluation_date: 5.days.from_now,
        created_at: 1.month.ago
      )
    end
    let!(:performance_evaluation) do
      create(
        :evaluation,
        :performance,
        evaluator: alice,
        evaluated: bob,
        evaluation_date: 1.week.ago,
        created_at: 3.months.ago
      )
    end
    let!(:expired_evaluation) do
      create(
        :evaluation,
        evaluator: alice,
        evaluated: bob,
        evaluation_date: 3.days.ago,
        created_at: 6.months.ago
      )
    end
    let!(:recent_evaluation) do
      create(
        :evaluation,
        evaluator: bob,
        evaluated: alice,
        evaluation_date: 1.day.ago,
        created_at: Date.today
      )
    end

    context 'with no options specified' do
      let(:options) { {} }

      it 'returns all evaluations' do
        result = call

        expect(result).to contain_exactly(english_evaluation, performance_evaluation, expired_evaluation, recent_evaluation)
      end
    end

    context 'with evaluator_id specified' do
      let(:options) { { evaluator_id: bob.id } }

      it 'returns evaluations from the given evaluator' do
        result = call

        expect(result).to contain_exactly(english_evaluation, recent_evaluation)
      end
    end

    context 'with evaluated_id specified' do
      let(:options) { { evaluated_id: bob.id } }

      it 'returns evaluations of the given evaluated' do
        result = call

        expect(result).to contain_exactly(performance_evaluation, expired_evaluation)
      end
    end

    context 'with questionnaire_type specified' do
      let(:options) { { questionnaire_type: 0 } }

      it 'returns evaluations with the given questionnaire type' do
        result = call

        expect(result).to contain_exactly(english_evaluation)
      end
    end

    context 'with created_at_start specified' do
      let(:options) { { created_at_start: 2.months.ago } }

      it 'returns evaluations created after or on the given start date' do
        result = call

        expect(result).to contain_exactly(recent_evaluation, english_evaluation)
      end
    end

    context 'with created_at_end specified' do
      let(:options) { { created_at_end: 2.months.ago } }

      it 'returns evaluations created before or on the given end date' do
        result = call

        expect(result).to contain_exactly(performance_evaluation, expired_evaluation)
      end
    end

    context 'with created_at_start and created_at_end specified' do
      let(:options) { { created_at_start: 8.months.ago, created_at_end: 3.months.ago } }

      it 'returns evaluations created within the given range' do
        result = call

        expect(result).to contain_exactly(expired_evaluation, performance_evaluation)
      end
    end

    context 'with evaluation_date_start specified' do
      let(:options) { { evaluation_date_start: 3.days.from_now } }

      it 'returns evaluations with evaluation dates after or on the given start date' do
        result = call

        expect(result).to contain_exactly(english_evaluation)
      end
    end

    context 'with evaluation_date_end specified' do
      let(:options) { { evaluation_date_end: 2.days.ago } }

      it 'returns evaluations with evaluation dates before or on the given end date' do
        result = call

        expect(result).to contain_exactly(performance_evaluation, expired_evaluation)
      end
    end

    context 'with multiple options specified' do
      let(:options) do
        {
          evaluator_id: alice.id,
          evaluated_id: bob.id,
          questionnaire_type: 1,
          created_at_start: 5.months.ago,
          created_at_end: Date.today,
          evaluation_date_start: 5.months.ago,
          evaluation_date_end: Date.today
        }
      end

      it 'returns evaluations that match all the given options' do
        result = call

        expect(result).to contain_exactly(performance_evaluation)
      end
    end
  end
end
