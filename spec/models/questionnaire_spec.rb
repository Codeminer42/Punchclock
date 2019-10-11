# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Questionnaire, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to enumerize(:kind).in(english:  0, performance: 1) }

    context 'when questionnaire is being used' do
      let(:evaluation)    { create(:evaluation) }
      let(:questionnaire) { evaluation.questionnaire }

      it 'can\'t be updated' do
        questionnaire.title = 'New Title'
        questionnaire.validate

        expect(questionnaire.errors[:base]).to include('cannot be changed. It\'s being used')
      end

      context 'when attribute to be changed is "active"' do
        it 'can be updated' do
          questionnaire.active = false

          expect(questionnaire).to be_valid
        end
      end
    end

    context 'when questionnaire is not being used' do
      let!(:questionnaire) { create(:questionnaire) }

      it 'can be updated' do
        questionnaire.title = 'New Title'
        questionnaire.validate

        expect(questionnaire.errors[:base]).not_to include('cannot be changed. It\'s being used')
      end
    end
  end

  describe '#toggle_active' do
  context 'when questionnaire is active' do
    let(:questionnaire) { create(:questionnaire, active: true) }

    it 'can be deactivated' do
      expect { questionnaire.toggle_active }.to change(questionnaire, :active).to(false)
    end
   end

  context "when questionnaire isn't active" do
    let(:questionnaire) { create(:questionnaire, active: false) }

    it 'can be activated' do
      expect { questionnaire.toggle_active }.to change(questionnaire, :active).to(true)
    end
   end
  end
end
