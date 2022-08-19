# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllocationsAndUnalocatedUsersQuery do
  describe '.call' do
    subject(:call) { described_class.new(Allocation, company).call }

    let(:company) { create(:company) }

    context 'when there are no allocations' do
      let!(:john) { create(:user, name: 'John Doe', company: company) }
      let!(:alex) { create(:user, name: 'Alex Doratov', company: company) }

      let(:names) { call.map { |allocation| allocation.user.name } }

      it 'returns unallocateds ordered by name' do
        expect(names).to eq ['Alex Doratov', 'John Doe']
      end
    end

    context 'when there are active allocations' do
      let!(:john) { create(:user, name: 'John Doe', company: company) }
      let!(:alex) { create(:user, name: 'Alex Doratov', company: company) }
      let!(:roan) { create(:user, name: 'Roan Britt', company: company) }
      let!(:brian) { create(:user, name: 'Brian May', company: company) }
      let!(:leeroy) { create(:user, name: 'Leeroy Jenkins', company: company) }
      let!(:satoshi) { create(:user, name: 'Satoshi Nakamoto', company: company) }

      let(:names) { call.map { |allocation| allocation.user.name } }

      before do
        create(:allocation,
               start_at: 2.months.after,
               end_at: 3.months.after,
               user: roan,
               company: company,
               ongoing: true)

        create(:allocation,
               start_at: 1.months.before,
               end_at: 4.months.after,
               user: brian,
               company: company,
               ongoing: true)

        create(:allocation,
               start_at: 3.months.after,
               end_at: nil,
               user: alex,
               company: company,
               ongoing: true)

        create(:allocation,
               start_at: 3.months.before,
               end_at: 2.months.before,
               user: leeroy,
               company: company)

        create(:allocation,
               start_at: 3.months.before,
               end_at: 2.months.before,
               user: satoshi,
               company: company,
               ongoing: true)
      end

      it 'returns users with ongoing allocations in order of finished > allocations about to finish > without end > no allocation' do
        expect(names).to eq ['Satoshi Nakamoto', 'Roan Britt', 'Brian May', 'Alex Doratov', 'John Doe', 'Leeroy Jenkins']
      end
    end

    context 'when there are inactive users' do
      let!(:roan) { create(:user, name: 'Roan Britt', company: company) }
      let!(:brian) { create(:user, name: 'Brian May', company: company) }

      let(:names) { call.map { |allocation| allocation.user.name } }

      before do
        brian.disable!
        create(:allocation,
               start_at: 3.months.after,
               end_at: 4.months.after,
               user: roan,
               company: company)

        create(:allocation,
               start_at: 3.months.ago,
               end_at: 2.months.ago,
               user: brian,
               company: company)
      end

      it 'returns only active users' do
        expect(names).to eq ['Roan Britt']
      end
    end
  end
end
