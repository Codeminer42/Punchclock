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

      let(:names) { call.map { |allocation| allocation.user.name } }

      before do
        create(:allocation,
               start_at: 2.months.after,
               end_at: 3.months.after,
               user: roan,
               company: company)

        create(:allocation,
               start_at: 3.months.after,
               end_at: 4.months.after,
               user: brian,
               company: company)
      end

      it 'returns unallocateds and actives' do
        expect(names).to eq ['Alex Doratov', 'John Doe', 'Roan Britt', 'Brian May']
      end
    end

    context 'when there are closed allocations' do
      let!(:john) { create(:user, name: 'John Doe', company: company) }
      let!(:alex) { create(:user, name: 'Alex Doratov', company: company) }
      let!(:roan) { create(:user, name: 'Roan Britt', company: company) }
      let!(:brian) { create(:user, name: 'Brian May', company: company) }

      let(:names) { call.map { |allocation| allocation.user.name } }

      before do
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

      it 'returns unallocateds, closed and actives' do
        expect(names).to eq ['Alex Doratov', 'John Doe', 'Brian May', 'Roan Britt']
      end
    end

    context 'when the user are inactive' do
      let!(:john) { create(:user, name: 'John Doe', company: company, active: false) }
      let!(:alex) { create(:user, name: 'Alex Doratov', company: company) }

      let(:names) { call.map { |allocation| allocation.user.name } }

      before do
        create(:allocation,
               start_at: 3.months.after,
               end_at: 4.months.after,
               user: john,
               company: company)

        create(:allocation,
               start_at: 3.months.ago,
               end_at: 2.months.ago,
               user: alex,
               company: company)
      end


      it 'returns only the active users allocated' do
        expect(names).to eq ['Alex Doratov']
      end
    end
  end
end
