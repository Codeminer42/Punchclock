# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContributionsByUserQuery do
  let(:offices) { create_list(:office, 3) }
  let(:user)    { create(:user, office: offices.first) }

  context '#to_hash' do
    subject(:to_hash) { described_class.new.to_hash }

    before do
      create_list(:contribution, 6, { user: user })
    end

    it 'returns the user name' do
      expect(subject.keys.first).to eq(user.id)
    end

    it 'returns the right number of contributions' do
      expect(subject[user.id]).to eq(6)
    end
  end

  context '#by_user' do
    subject(:by_user) { described_class.new.by_user }

    before do
      create_list(:contribution, 3, { user: user })
    end

    it 'returns contributions of users' do
      expect(subject.to_hash.keys).to include(user.id)
    end
  end

  context '#per_month' do
    subject(:per_month) { described_class.new.per_month(1) }

    before do
      travel_to Date.new(2022, 1, 15)
      create_list(:contribution, 3, { user: user })
      create_list(:contribution, 3,
                  { user: user, created_at: Date.today.last_month })
    end

    it 'returns the right number of contributions' do
      expect(subject.to_hash.first.last).to eq(3)
    end
  end

  context '#approved' do
    subject(:approved) { described_class.new.approved }

    before do
      create_list(:contribution, 3, { user: user })
      create_list(:contribution, 3, { user: user, state: :approved })
    end

    it 'returns the right number of contributions' do
      expect(subject.to_hash.first.last).to eq(3)
    end
  end
end
