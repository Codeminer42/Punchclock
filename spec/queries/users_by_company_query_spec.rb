require 'rails_helper'

RSpec.describe UsersByCompanyQuery do
  let(:company) { create(:company) }
  let(:project) { create(:project, company: company) }
  let(:user_allocated) { create(:user, company: company) }
  let(:user_not_allocated) { create(:user, company: company) }

  before do
    create(:allocation,
           :with_end_at,
           start_at: Date.new(2019, 6, 17),
           user: user_allocated,
           project: project,
           company: company)
  end

  subject { UsersByCompanyQuery.new(company) }

  describe '#not_allocated_including' do
    context 'when passes user allocated' do
      let(:expected_array) { [user_not_allocated, user_allocated] }

      it 'return all users not allocated including user passed' do
        expect(subject.not_allocated_including(user_allocated)).to match_array expected_array
      end
    end

    context 'when not passes user allocated' do
      let(:expected_array) { [user_not_allocated] }

      it 'return all users not allocated' do
        expect(subject.not_allocated_including).to match_array expected_array
      end
    end
  end
end
