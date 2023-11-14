require 'rails_helper'

RSpec.describe ContributionsTextService do
  describe '#all' do
    subject(:text) { described_class.call(contributions) }

    context 'with a single contribution' do
      let(:office) { create(:office, city: 'Campinas') }
      let(:user) { 
        create(:user, :with_contributions, name: 'John Doe', 
          github: 'johndoe', office: office, contributions_count: 1) 
      }
  
      let(:contributions) { user.contributions }

      it 'returns contribution data' do
        expect(text).to include(contributions.take.link)
        expect(text).to include('John Doe')
        expect(text).to include('johndoe')
        expect(text).to include('Campinas')
        expect(text).to include("1 PR's")
        expect(text).to include('1 Miners')
      end
    end

    context 'with multiple contributions for the same user' do
      let(:office) { create(:office, city: 'Campinas') }
      let(:user) { 
        create(:user, :with_contributions, name: 'John Doe', 
          github: 'johndoe', office: office, contributions_count: 3) 
      }

      let(:contributions) { user.contributions }

      it 'returns contribution data' do
        expect(text).to include(contributions.first.link)
        expect(text).to include(contributions.second.link)
        expect(text).to include(contributions.last.link)
        expect(text).to include('John Doe')
        expect(text).to include('johndoe')
        expect(text).to include('Campinas')
        expect(text).to include("3 PR's")
        expect(text).to include('1 Miners')
      end
    end

    context 'with multiple users' do
      let!(:user1) { create(:user, :with_contributions, contributions_count: 1) }
      let!(:user2) { create(:user, :with_contributions, contributions_count: 1) }

      let(:contributions) { Contribution.all }

      it 'returns contribution data' do
        expect(text).to include(user1.contributions.take.link)
        expect(text).to include(user1.name)
        expect(text).to include(user1.github)
        expect(text).to include(user1.office.city)
        expect(text).to include(user2.contributions.take.link)
        expect(text).to include(user2.name)
        expect(text).to include(user2.github)
        expect(text).to include(user2.office.city)
        expect(text).to include("2 PR's")
        expect(text).to include('2 Miners')
      end
    end
  end
end
