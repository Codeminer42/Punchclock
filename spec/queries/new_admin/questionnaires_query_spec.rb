require 'rails_helper'

RSpec.describe NewAdmin::QuestionnairesQuery do
  describe '#self.call' do
    context 'when no filters are applied' do
      let(:questionnaires) { create_list(:questionnaire, 2) }

      it 'retrieves the questionnaires' do
        expect(described_class.call({})).to match_array(questionnaires)
      end
    end

    context 'when filters are applied' do
      let!(:active_questionnaires) { create_list(:questionnaire, 2) }
      let!(:inactive_questionnaires) { create_list(:questionnaire, 2, active: false) }
      let!(:english_questionnaires) { create_list(:questionnaire, 2, :kind_english) }

      it 'retrieves filtered projects' do
        filters = { active: true, kind: 'english' }

        expect(described_class.call(filters)).to match_array(english_questionnaires)
      end
    end
  end
end
