# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllocationsAndUnalocatedUsersQuery do
  describe '.call' do
    subject(:call) { described_class.new(Allocation).call }

    context 'when there are no allocations' do
      let!(:john) { create(:user, name: 'John Doe') }
      let!(:alex) { create(:user, name: 'Alex Doratov') }

      let(:names) { call.map { |allocation| allocation.user.name } }

      it 'returns unallocateds ordered by name' do
        expect(names).to eq ['Alex Doratov', 'John Doe']
      end
    end

    context 'when there are active allocations' do
      let!(:john) { create(:user, name: 'John Doe') }
      let!(:alex) { create(:user, name: 'Alex Doratov') }
      let!(:roan) { create(:user, name: 'Roan Britt') }
      let!(:brian) { create(:user, name: 'Brian May') }
      let!(:leeroy) { create(:user, name: 'Leeroy Jenkins') }
      let!(:satoshi) { create(:user, name: 'Satoshi Nakamoto') }

      let(:names) { call.map { |allocation| allocation.user.name } }

      before do
        create(:allocation,
               start_at: 2.months.after,
               end_at: 3.months.after,
               user: roan,
               ongoing: true)

        create(:allocation,
               start_at: 1.months.before,
               end_at: 4.months.after,
               user: brian,
               ongoing: true)

        create(:allocation,
               start_at: 3.months.after,
               end_at: 4.months.after + 1,
               user: alex,
               ongoing: true)

        create(:allocation,
               start_at: 3.months.before,
               end_at: 2.months.before,
               user: leeroy)

        create(:allocation,
               start_at: 3.months.before,
               end_at: 2.months.before,
               user: satoshi,
               ongoing: true)
      end

      it 'returns users with ongoing allocations in order of finished > allocations about to finish > without end > no allocation' do
        expect(names).to eq ['Satoshi Nakamoto', 'Roan Britt', 'Brian May', 'Alex Doratov', 'John Doe', 'Leeroy Jenkins']
      end
    end

    context 'when there are inactive users' do
      let!(:roan) { create(:user, name: 'Roan Britt') }
      let!(:brian) { create(:user, name: 'Brian May') }

      let(:names) { call.map { |allocation| allocation.user.name } }

      before do
        brian.disable!
        create(:allocation,
               start_at: 3.months.after,
               end_at: 4.months.after,
               user: roan)

        create(:allocation,
               start_at: 3.months.ago,
               end_at: 2.months.ago,
               user: brian)
      end

      it 'returns only active users' do
        expect(names).to eq ['Roan Britt']
      end
    end

    context 'when there are more than one active and the other allocation is in the future' do
      let!(:roan) { create(:user, name: 'Roan Britt') }

      before do
        create(:allocation,
               start_at: Time.zone.today,
               end_at: 1.months.after,
               user: roan,
               ongoing: true)

        create(:allocation,
               start_at: 2.months.after,
               end_at: 3.months.after,
               user: roan)
      end

      it 'returns only active allocation for that user user' do
        expect(call.pluck(:id)).to eq roan.allocations.ongoing.pluck(:id)
      end
    end
  end
end
