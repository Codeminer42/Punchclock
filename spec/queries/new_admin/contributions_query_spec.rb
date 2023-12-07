require 'rails_helper'

RSpec.describe NewAdmin::ContributionsQuery do
  describe '#self.call' do
    context 'when no filters are applied' do
      let!(:contributions) { create_list(:contribution, 2, :with_users) }

      it 'retrieves the contributions' do
        expect(described_class.call({})).to match_array(contributions)
      end
    end

    context 'when filters are applied' do
      let!(:approved_contributions) { create_list(:contribution, 2, :approved) }
      let!(:user) { create(:user) }
      let!(:user_contribution) { create(:contribution, :approved) }

      it 'retrieves filtered projects' do
        user_contribution.users << user
        filters = { user_id: user.id, state: 'approved' }

        expect(described_class.call(filters)).to contain_exactly(user_contribution)
      end
    end
  end
end
