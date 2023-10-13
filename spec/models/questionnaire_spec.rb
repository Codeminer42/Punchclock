# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Questionnaire, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to enumerize(:kind).in(english: 0, performance: 1) }

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

  describe 'scopes' do
    describe '#active' do
      let(:active_questionnaire_list) { create_list :questionnaire, 2 }
      let(:inactive_questionnaire) { create(:questionnaire, active: false) }

      it 'returns only the active questionnaires' do
        expect(Questionnaire.active).to match_array(active_questionnaire_list)
      end
    end

    describe '#by_title_like' do
      let!(:questionnaire1) { create(:questionnaire, title: 'first questionnaire') }
      let!(:questionnaire2) { create(:questionnaire, title: 'second questionnaire') }

      context 'when title is present' do
        it 'filters questionnaires by title' do
          expect(Questionnaire.by_title_like('second')).to eq([questionnaire2])
        end
      end

      context 'when title is not present' do
        it 'does not filter by title' do
          expect(Questionnaire.by_title_like(nil)).to eq([questionnaire1, questionnaire2])
        end
      end
    end

    describe '#by_kind' do
      let!(:performance_questionnaire) { create(:questionnaire) }
      let!(:english_questionnaire) { create(:questionnaire, :kind_english) }

      context 'when kind is present' do
        it 'filters by kind' do
          expect(Questionnaire.by_kind('performance')).to eq([performance_questionnaire])
        end
      end

      context 'when kind is not present' do
        it 'does not filter' do
          expect(Questionnaire.by_kind(nil)).to eq([performance_questionnaire, english_questionnaire])
        end
      end
    end

    describe '#by_created_at_from' do
      let!(:october_questionnaire) { create(:questionnaire, created_at: '2022-10-02') }
      let!(:november_questionnaire) { create(:questionnaire, created_at: '2022-11-02') }

      context 'when date is present' do
        it 'returns questionnaires created from given date' do
          expect(Questionnaire.by_created_at_from('2022-11-01')).to eq([november_questionnaire])
        end
      end

      context 'when date is not present' do
        it 'does not filter by date' do
          expect(Questionnaire.by_created_at_from(nil)).to eq([october_questionnaire, november_questionnaire])
        end
      end
    end

    describe '#by_created_at_until' do
      let!(:october_questionnaire) { create(:questionnaire, created_at: '2022-10-02') }
      let!(:november_questionnaire) { create(:questionnaire, created_at: '2022-11-02') }

      context 'when date is present' do
        it 'returns questionnaires created until given date' do
          expect(Questionnaire.by_created_at_until('2022-10-10')).to eq([october_questionnaire])
        end
      end

      context 'when date is not present' do
        it 'does not filter by date' do
          expect(Questionnaire.by_created_at_from(nil)).to eq([october_questionnaire, november_questionnaire])
        end
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
