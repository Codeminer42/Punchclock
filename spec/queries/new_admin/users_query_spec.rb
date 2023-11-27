require 'rails_helper'

RSpec.describe NewAdmin::UsersQuery do
  describe '#self.call' do
    context 'when no filters are applied' do
      let(:users) { create_list(:user, 2) }

      it 'retrieves the users' do
        expect(described_class.call({})).to match_array(users)
      end
    end

    context 'when filters are applied' do
      let!(:active_users) { create_list(:user, 2, active: true) }
      let!(:inactive_users) { create_list(:user, 2, active: false) }

      it 'retrieves the filtered users' do
        filters = { active: true }

        expect(described_class.call(filters)).to match_array(active_users)
      end
    end
  end
end
