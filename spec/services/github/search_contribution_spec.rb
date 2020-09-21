require 'rails_helper'

RSpec.describe Github::SearchContribution, type: :service do
  describe '.perform' do

    subject { described_class.new.perform } 

    context 'when PR exist', vcr: true do
      let!(:repository) { create(:repository, link: 'https://github.com/forem/forem') }
      let!(:user) { create(:user, github: 'brunnohenrique') }

      it 'creates contribution' do 
        expect { subject }.to change(Contribution, :count).by(1)
      end
    end

    context 'when PR does not exist', vcr: true do
      let!(:repository) { create(:repository, link: 'https://github.com/ruby/ruby') }
      let!(:user) { create(:user, github: 'brunnohenrique') }

      it 'do not creates contribution' do 
        expect { subject }.to change(Contribution, :count).by(0)
      end      
    end
  end
end
