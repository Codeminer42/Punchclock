# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateContributionService do
  describe '.call' do
    subject(:result) { described_class.new.call(contributions_params) }
    let(:link) { 'https://github.com/project/teste/pull/1' }
    let!(:user) { create(:user, github: 'github') }

    context 'when not found user' do
      let(:contributions_params) { { user: 0, link: link } }

      it 'returns status not_found' do
        expect(result.status).to eq(:not_found)
      end

      it 'returns error message' do
        expect(result.json).to eq({ message: 'User not found' })
      end
    end

    context 'when user and link is valid' do
      let(:contributions_params) { { user: 'github', link: link } }

      it 'returns status created' do
        expect(result.status).to eq(:created)
      end

      it 'returns contribution with user ' do
        expect(result.json.user_id).to eq(user.id)
      end

      it 'returns contribution with link ' do
        expect(result.json.link).to eq(link)
      end
    end

    context 'when exists a contribution with the same link' do
      let(:contributions_params) { { user: 'github', link: link } }

      before { create(:contribution, user: user, link: link) }

      it 'returns status unprocessable_entity' do
        expect(result.status).to eq(:unprocessable_entity)
      end

      it 'return error message' do
        expect(result.json[:message].messages).to eq(link: ['já está em uso'])
      end
    end
  end
end
