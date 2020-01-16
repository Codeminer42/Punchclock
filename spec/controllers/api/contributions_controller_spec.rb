# frozen_string_literal: true

require 'spec_helper'

describe Api::ContributionsController, type: :controller do
  let!(:user) { create(:user, github: 'github') }
  let(:params) { { token: 'ApiToken', user: 'github', link: 'https://github.com/user/project/pull/1' } }

  describe 'POST open-source/contributions' do
    subject { post :create, params: params }

    context 'when contribution params are valid' do
      it { is_expected.to have_http_status(:created) }

      it 'returns content type json' do
        expect(subject.content_type).to eq 'application/json'
      end

      it 'returns contribution' do
        expect(JSON.parse(subject.body)).to include(
          'user_id' => user.id,
          'company_id' => user.company_id,
          'link' => params[:link],
          'state' => 'received'
        )
      end
    end

    context 'when user is not found' do
      before { params[:user] = 'teste' }

      it { is_expected.to have_http_status(:not_found) }

      it 'returns content type json' do
        expect(subject.content_type).to eq 'application/json'
      end

      it 'returns user not found message' do
        expect(JSON.parse(subject.body)).to eq( {
          'message' => 'User not found',
        })
      end
    end

    context 'when it already exists a contribution with same link' do
      before { create(:contribution, user: user, link: params[:link]) }

      it { is_expected.to have_http_status(:unprocessable_entity) }

      it 'returns content type json' do
        expect(subject.content_type).to eq 'application/json'
      end

      it 'returns errors message' do
        expect(JSON.parse(subject.body)).to eq( {
          'message' => {
            'link' => [
              'já está em uso'
            ]
          }
        })
      end
    end
  end
end
