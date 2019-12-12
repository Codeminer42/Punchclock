# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllocationsAndUnalocatedUsersQuery do
  describe '.call' do
    let(:company) { create(:company) }
    context 'when user not have allocation' do
      context 'and is not engineer' do
        let!(:user) { create(:user, occupation: 'administrative', company: company) }

        it 'returns empty relation' do
          expect(described_class.call(company)).to be_empty
        end
      end

      context 'and is engineer' do
        let!(:user) { create(:user, company: company) }
        it 'returns relation with allocations attributes
          null and with user_id equal user.id' do

          expect(described_class.call(company)[0].user_id).to eq(user.id)
        end
      end
    end

    context 'when user have allocation' do
      let(:user) { create(:user, company: company) }
      let!(:last_allocation) do
        create(:allocation,
               start_at: Date.new(2019, 1, 13),
               end_at: Date.new(2019, 1, 17),
               user: user,
               company: company,
               created_at: Date.today,
               updated_at: Date.today)
      end

      before do
        create(:allocation,
               :with_end_at,
               start_at: Date.new(2019, 1, 6),
               end_at: Date.new(2019, 1, 8),
               user: user,
               company: company)
      end

      it 'return last allocation' do
        expect(described_class.call(company)[0]).to eql(last_allocation)
      end

      context 'and has users without allocation' do
        let!(:user_not_allocated) { create(:user, company: company) }
        let(:allocation) { Allocation.new(user_id: user_not_allocated.id) }
        let(:expect_attributes) { [allocation, last_allocation] }

        it 'returns first users without allocation and
          then returns the last allocation of users who have allocated' do
          expect(described_class.call(company).map(&:attributes)).to eq(expect_attributes.map(&:attributes))
        end
      end
    end
  end
end
