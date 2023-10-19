# frozen_string_literal: true

require 'spec_helper'

describe ActiveAdmin::StatsHelper do
  describe '#constributions_offices_data' do
    let!(:office) { create(:office) }
    let!(:office_with_no_contribution) { create(:office) }
    let(:user) { create(:user, office: office) }
    let(:user_no_contributions) { create(:user, office: office) }

    let!(:contribution) { create(:contribution, :approved, users: [user]) }

    describe 'returned hash' do
      let!(:data) do
        helper.constributions_offices_data(ContributionsByOfficeQuery.new.approved.to_relation)
      end

      it 'includes correct number_of_contributions for office' do
        expect(data).to include(office.city => 1)
      end

      it 'includes correct number_of_contributions for office_with_no_contributions' do
        expect(data).to include(office_with_no_contribution.city => 0)
      end
    end

    describe '#constributions_users_data' do
      let!(:data) do
        contribs = ContributionsByUserQuery.new.approved.to_hash

        helper.constributions_users_data(
          contributions: contribs,
          limit: 5
        )
      end

      it 'includes correct number of contributions by user' do
        expect(data).to include(user.name => 1)
      end

      it 'includes correct number of contributions for user without contributions' do
        expect(data).not_to include(user_no_contributions.name => 0)
      end
    end
  end
end
