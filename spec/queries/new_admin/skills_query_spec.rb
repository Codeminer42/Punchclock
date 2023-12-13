require 'rails_helper'

RSpec.describe NewAdmin::SkillsQuery do
  describe '#self.call' do
    context 'when no filters are applied' do
      let(:skills) { create_list(:skill, 2) }

      it 'retrieves the skills' do
        expect(described_class.call({})).to match_array(skills)
      end
    end

    context 'when filters are applied' do
      let!(:skill1) { create(:skill, title: 'foo') }
      let!(:skill2) { create(:skill, title: 'bar') }

      it 'retrieves filtered skills' do
        filters = { title: 'ba'}

        expect(described_class.call(filters)).to contain_exactly(skill2)
      end
    end
  end
end
