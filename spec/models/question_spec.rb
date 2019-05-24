# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:kind) }

    context 'when question kind is multiple choice' do
      context 'and raw answer options is empty' do
        let(:invalid_question) { build(:question, :multiple_choice, raw_answer_options: '') }

        it 'raises error' do
          invalid_question.validate

          expect(invalid_question.errors[:raw_answer_options]).to include('não pode ficar em branco')
        end
      end

      context 'and raw answer options is filled' do
        subject { build(:question, :multiple_choice) }

        it { is_expected.to be_valid }
      end
    end
  end

  describe 'Given a multiple choice question' do
    let!(:question) { create(:question, :multiple_choice) }

    context 'when raw answer options is assigned' do
      it 'changes answer option' do
        expect { question.raw_answer_options = 'New; Options' }.to change(question, :answer_options)
      end
    end
  end

  describe '#answer_options_to_string' do
    describe 'Given a multiple choice question with answer options as array' do
      let!(:question) { create(:question, :multiple_choice) }

      it 'returns all options separated by ; as string' do
        expect(Question.last.answer_options_to_string).to eq('Answer; Options')
      end
    end
  end
end
