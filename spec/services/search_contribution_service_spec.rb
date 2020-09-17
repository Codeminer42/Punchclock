# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchContributionService do
  describe '.perform' do

    subject { described_class.new.perform } 

    context 'when the PR was found', vcr: true do
      let!(:repository) { create(:repository, link: 'https://github.com/jquense/yup') }
      let!(:user) { create(:user, github: 'abnersajr') }

      it 'Contribution was created' do 
        expect { subject }.to change(Contribution, :count).by(2)
      end
    end

    context 'when the PR was not found', vcr: true do
      let!(:repository) { create(:repository, link: 'https://github.com/ruby/ruby') }
      let!(:user) { create(:user, github: 'abnersajr') }

      it 'Contribution was created' do 
        expect { subject }.to change(Contribution, :count).by(0)
      end      
    end
  end
end
