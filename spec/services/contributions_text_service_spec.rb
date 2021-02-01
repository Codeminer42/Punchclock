require 'rails_helper'

RSpec.describe ContributionsTextService do
  describe '#all' do
    subject(:text) { described_class.call(contributions) }

    let(:office) { create(:office, city: 'Campinas') }
    let(:user) { create(:user, name: 'John Doe', github: 'johndoe', office: office) }

    context 'with a single contribution' do
      let!(:contribution) { create(:contribution,user: user) }

      let(:contributions) { user.contributions }

      it 'returns contribution data' do
        expect(text).to include(contribution.link)
        expect(text).to include('John Doe')
        expect(text).to include('johndoe')
        expect(text).to include('Campinas')
        expect(text).to include("1 PR's")
        expect(text).to include('1 Miners')
      end
    end

    context 'with multiple contributions for the same user' do
      let!(:contribution1) { create(:contribution,user: user) }
      let!(:contribution2) { create(:contribution,user: user) }
      let!(:contribution3) { create(:contribution,user: user) }

      let(:contributions) { user.contributions }

      it 'returns contribution data' do
        expect(text).to include(contribution1.link)
        expect(text).to include(contribution2.link)
        expect(text).to include(contribution3.link)
        expect(text).to include('John Doe')
        expect(text).to include('johndoe')
        expect(text).to include('Campinas')
        expect(text).to include("3 PR's")
        expect(text).to include('1 Miners')
      end
    end

    context 'with multiple users' do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }

      let!(:contribution1) { create(:contribution,user: user1) }
      let!(:contribution2) { create(:contribution,user: user2) }

      let(:contributions) { Contribution.where(user_id: [user1.id, user2.id]) }

      it 'returns contribution data' do
        expect(text).to include(contribution1.link)
        expect(text).to include(user1.name)
        expect(text).to include(user1.github)
        expect(text).to include(user1.office.city)
        expect(text).to include(contribution2.link)
        expect(text).to include(user2.name)
        expect(text).to include(user2.github)
        expect(text).to include(user2.office.city)
        expect(text).to include("2 PR's")
        expect(text).to include('2 Miners')
      end
    end
  end
end
