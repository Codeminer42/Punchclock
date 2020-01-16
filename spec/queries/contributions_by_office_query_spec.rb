require 'rails_helper'

RSpec.describe ContributionsByOfficeQuery do
  let(:company) { create(:company) }
  let(:offices) { create_list(:office, 3, { company: company }) }

  subject { ContributionsByOfficeQuery.new }
  
  context 'to_relation' do
    before do
      user = create(:user, company: company, office: offices.first)

      create_list(:contribution, 6, { user: user, company: company })
    end

    it 'return the office' do
      expect(subject.to_relation.first.city).to eq(offices.first.city) 
    end

    it 'return the right number of contributions' do
      expect(subject.to_relation.first.number_of_contributions).to eq(6)
    end
  end

  context 'leaderboard' do
    before do
      3.times do |n|
        user = create(:user, company: company, office: offices[n])

        create_list(:contribution, 3 - n, { user: user, company: company })
      end
    end
    
    it 'limits the size of relation' do
      expect(subject.leaderboard(limit = 2).to_relation.length).to eq(2)
    end

    it 'orders by descending number_of_contributions' do
      relation = subject.leaderboard(limit = 2).to_relation
      expect(relation.first.number_of_contributions).to be > relation.last.number_of_contributions
    end
  end

  context 'this_week' do
    before do
      user = create(:user, company: company, office: offices.first)

      create_list(:contribution, 3, { user: user, company: company })
      create_list(:contribution, 3, { user: user, company: company, created_at: 1.week.ago })
    end

    it 'return the right number of contributions' do
      expect(subject.this_week.to_relation.first.number_of_contributions).to eq(3)
    end
  end

  context 'n_weeks_ago' do
    before do
      user = create(:user, company: company, office: offices.first)

      create_list(:contribution, 3, { user: user, company: company })
      create_list(:contribution, 3, { user: user, company: company, created_at: 2.week.ago })
    end

    it 'return the right number of contributions' do
      expect(subject.n_weeks_ago(2).to_relation.first.number_of_contributions).to eq(3)
    end
  end

  context 'approved' do
    before do
      user = create(:user, company: company, office: offices.first)

      create_list(:contribution, 3, { user: user, company: company })
      create_list(:contribution, 3, { user: user, company: company, state: :approved })
    end

    it 'return the right number of contributions' do
      expect(subject.approved.to_relation.first.number_of_contributions).to eq(3)
    end
  end
end
