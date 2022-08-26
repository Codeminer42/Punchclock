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
           ongoing: true,
           company: company)
  end

  subject { UsersByCompanyQuery.new(company) }

  describe '#not_allocated_including' do
    context 'when passes user allocated' do
      it 'return all users not allocated including user passed' do
        result = subject.not_allocated_including(user_allocated)
        expect(result).to containing_exactly(user_not_allocated, user_allocated)
      end
    end

    context 'when not passes user allocated' do
      it 'return all users not allocated' do
        expect(subject.not_allocated_including).to contain_exactly user_not_allocated
      end
    end
  end
end
