# frozen_string_literal: true

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

  context 'by_company' do
    before do
      user = create(:user, company: company, office: offices.first)

      other_company = create(:company)
      @other_office = create(:office, { company: other_company })
      other_user = create(:user, company: other_company, office: @other_office)

      create_list(:contribution, 3, { user: user, company: company })
      create_list(:contribution, 5, { user: other_user, company: other_company })
    end

    it 'return contributions of company' do
      expect(subject.by_company(company).to_relation.map(&:city)).to include(offices.first.city)
    end

    it 'does not return contributions of other_company' do
      expect(subject.by_company(company).to_relation.map(&:city)).not_to include(@other_office.city)
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

  context 'per_month' do
    before do
      user = create(:user, company: company, office: offices.first)

      create_list(:contribution, 3, { user: user, company: company })
      create_list(:contribution, 3, { user: user, company: company, created_at: Date.new(2020, 0o6) })
    end

    it 'return the right number of contributions' do
      expect(subject.per_month(6).to_relation.first.number_of_contributions).to eq(3)
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
      create_list(:contribution, 3, :with_valid_repository, { user: user, company: company, state: :approved })
    end

    it 'return the right number of contributions' do
      expect(subject.approved.to_relation.first.number_of_contributions).to eq(3)
    end
  end
end
