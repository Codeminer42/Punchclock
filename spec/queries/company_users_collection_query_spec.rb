# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyUsersCollectionQuery do
  describe '.call' do
    subject(:call) { described_class.new(admin).call }

    let(:company1) { create(:company) }
    let!(:user1) { create(:user, company: company1, name: 'userC') }
    let!(:user2) { create(:user, company: company1, name: 'userD') }

    let(:company2) { create(:company) }
    let!(:user3) { create(:user, company: company2, name: 'userA') }
    let!(:user4) { create(:user, company: company2, name: 'userB') }

    context 'when user is super admin' do
      let(:admin) { create(:user, :super_admin, company: company1, name: 'superadmin') }

      it 'returns unallocateds ordered by name' do
        expect(call).to eq [
          [company1, [[admin.name, admin.id], [user1.name, user1.id], [user2.name, user2.id]]],
          [company2, [[user3.name, user3.id], [user4.name, user4.id]]]
        ]
      end
    end

    context 'when is not super admin' do
      let(:admin) { create(:user, :admin, company: company1, name: 'superadmin') }

      it 'returns unallocateds ordered by name' do
        expect(call).to eq [
          [company1, [[admin.name, admin.id], [user1.name, user1.id], [user2.name, user2.id]]]
        ]
      end
    end
  end
end
