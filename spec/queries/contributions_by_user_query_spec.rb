# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContributionsByUserQuery do
  context '#to_hash' do
    let!(:offices) { create_list(:office, 3) }
    let!(:user)    { 
      create(:user, :with_contributions, office: offices.first, contributions_count: 6) 
    }

    subject(:to_hash) { described_class.new.to_hash }

    it 'returns the user name' do
      expect(subject.keys.first).to eq(user.id)
    end

    it 'returns the right number of contributions' do
      expect(subject[user.id]).to eq(6)
    end
  end

  context '#by_user' do
    let!(:offices) { create_list(:office, 3) }
    let!(:user)    { 
      create(:user, :with_contributions, office: offices.first, contributions_count: 3) 
    }

    subject(:by_user) { described_class.new }

    it 'returns contributions of users' do
      expect(subject.to_hash.keys).to include(user.id)
    end
  end

  context '#per_month' do
    let!(:offices) { create_list(:office, 3) }
    let!(:user)    { create(:user, office: offices.first) }

    before do
      travel_to Date.new(2022, 1, 15)

      create_list(:contribution, 3, { users: [user] })
      create_list(:contribution, 3,
                  { users: [user], created_at: Date.today.last_month })
    end

    subject(:per_month) { described_class.new.per_month(1) }

    it 'returns the right number of contributions' do

      expect(subject.to_hash.first.last).to eq(3)
    end
  end

  context '#approved' do
    let!(:offices) { create_list(:office, 3) }
    let!(:user)    { create(:user, office: offices.first) }

    before do
      create_list(:contribution, 3, { users: [user] })
      create_list(:contribution, 3, { users: [user], state: :approved })
    end

    subject(:approved) { described_class.new.approved }

    it 'returns the right number of contributions' do
      expect(subject.to_hash.first.last).to eq(3)
    end
  end
end
