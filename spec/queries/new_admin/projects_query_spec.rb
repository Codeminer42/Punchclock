# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::ProjectsQuery do
  describe '#self.call' do
    context 'when no filters is applied' do
      let(:projects) { create_list(:project, 2) }

      it 'retrieves projects' do
        expect(described_class.call({})).to match_array(projects)
      end
    end

    context 'when filters are applied' do
      let!(:active_projects) { create_list(:project, 2, :active) }
      let!(:inactive_projects) { create_list(:project, 2, :inactive) }

      it 'retireve filtered projects' do
        filters = { active: true }

        expect(described_class.call(filters)).to match_array(active_projects)
      end
    end
  end
end
