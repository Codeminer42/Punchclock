# frozen_string_literal: true

require 'spec_helper'

describe ActiveAdmin::StatsHelper do
  describe '#stats_data' do
    let(:company) { create(:company) }
    let!(:office) { create(:office, { company: company }) }
    let!(:office_with_no_contribution) { create(:office, { company: company }) }
    let(:user) { create(:user, company: company, office: office) }

    let!(:contribution) { create(:contribution, :approved, user: user, company: company) }

    describe 'returned hash' do
      let!(:data) do
        helper.stats_data(ContributionsByOfficeQuery.new.by_company(company).approved.to_relation)
      end

      it 'includes correct number_of_contributions for office' do
        expect(data).to include(office.city => 1)
      end

      it 'includes correct number_of_contributions for office_with_no_contributions' do
        expect(data).to include(office_with_no_contribution.city => 0)
      end
    end
  end
end
