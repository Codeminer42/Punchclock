# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContributionsByOfficeQuery do
  
  subject { ContributionsByOfficeQuery.new }
  
  context 'to_relation' do
    let(:offices) { create_list(:office, 3) }

    before do
      create(:user, :with_contributions, office: offices.first, contributions_count: 6)
    end

    it 'return the office' do
      expect(subject.to_relation.first.city).to eq(offices.first.city)
    end

    it 'return the right number of contributions' do
      expect(subject.to_relation.first.number_of_contributions).to eq(6)
    end
  end

  context 'by_office' do
    let(:offices) { create_list(:office, 3) }

    before do
      create(:user, :with_contributions, office: offices.first, contributions_count: 3)
    end

    it 'return contributions' do
      expect(subject.to_relation.map(&:city)).to include(offices.first.city)
    end
  end

  context 'leaderboard' do
    let(:offices) { create_list(:office, 3) }

    before do
      3.times do |n|
        create(:user, :with_contributions, office: offices[n], contributions_count: 3 - n)
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
    let(:offices) { create_list(:office, 3) }

    before do
      travel_to '2022-01-01'.to_date
      user = create(:user, office: offices.first)

      create_list(:contribution, 3, { users: [user] })
      create_list(:contribution, 4, { users: [user], created_at: 1.month.ago })
      create_list(:contribution, 5, { users: [user], created_at: 13.month.ago })
    end

    it 'return the right number of contributions' do
      expect(subject.this_week.to_relation.first.number_of_contributions).to eq(3)
    end
  end

  context 'per_month' do
    let(:offices) { create_list(:office, 3) }

    around do |example|
      travel_to(DateTime.new(2022,01, 01), &example)
    end

    before do
      travel_to '2022-01-01'.to_date

      user = create(:user, office: offices.first)

      create_list(:contribution, 3, { users: [user] })
      create_list(:contribution, 4, { users: [user], created_at: 1.month.ago })
      create_list(:contribution, 5, { users: [user], created_at: 13.month.ago })
    end

    it 'return the right number of contributions' do
      expect(subject.per_month(1.month.ago).to_relation.first.number_of_contributions).to eq(4)
    end

    it 'return the right number of contributions from more than 1 year ago' do
      expect(subject.per_month(13.month.ago).to_relation.first.number_of_contributions).to eq(5)
    end
  end

  context 'n_weeks_ago' do
    let(:offices) { create_list(:office, 3) }

    before do
      user = create(:user, office: offices.first)

      create_list(:contribution, 3, { users: [user] })
      create_list(:contribution, 3, { users: [user], created_at: 2.week.ago })
    end

    it 'return the right number of contributions' do
      expect(subject.n_weeks_ago(2).to_relation.first.number_of_contributions).to eq(3)
    end
  end

  context 'approved' do
    let(:offices) { create_list(:office, 3) }

    before do
      user = create(:user, office: offices.first)

      create_list(:contribution, 3, { users: [user] })
      create_list(:contribution, 3, { users: [user], state: :approved })
    end

    it 'return the right number of contributions' do
      expect(subject.approved.to_relation.first.number_of_contributions).to eq(3)
    end
  end
end
