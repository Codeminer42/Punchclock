require 'rails_helper'

RSpec.describe UsersByCompanyQuery do
  let(:company) { create(:company) }
  let(:project) { create(:project, company: company) }
  let(:user_allocated) { create(:user, company: company) }
  let(:user_not_allocated) { create(:user, company: company) }
  let(:non_engineer) { create(:user, occupation: 'administrative', company: company) }
  let(:inactive) { create(:user, company: company, active: false) }

  before do
    create(:allocation,
           start_at: Date.new(2019, 6, 17),
           user: user_allocated,
           project: project,
           ongoing: true,
           company: company)
  end

  subject { UsersByCompanyQuery.new(company) }

  describe '#active_engineers' do
    context 'are active engineers' do
      it 'return all users' do
        result = subject.active_engineers
        expect(result).to contain_exactly(user_not_allocated, user_allocated)
      end
    end

    context 'when the user it is not an engineer' do
      it 'user is not returned' do
        expect(subject.active_engineers).not_to include non_engineer
      end
    end

    context 'when the user it is not active' do
      it 'user is not returned' do
        expect(subject.active_engineers).not_to include inactive
      end
    end
  end
end
