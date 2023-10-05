require 'spec_helper'

describe Api::V1::AllocationsController, type: :controller do
  let(:user) { create(:user) }

  before { login user }

  describe 'GET api/v1/allocations/current' do
    subject(:request) { get :current }

    it { is_expected.to have_http_status(:ok) }

    it 'returns content type json' do
      expect(request.content_type).to eq 'application/json; charset=utf-8'
    end

    it 'returns current allocation' do
      current_allocation = build(:allocation, user:, id: 7)

      allow_any_instance_of(User).to receive(:current_allocation).and_return current_allocation

      expect(subject.body).to eq(
        {
          currentAllocation: {
            id: current_allocation.id
          }
        }.to_json
      )
    end

    context 'when user has no current allocation' do
      it 'returns an empty id' do
        expect(subject.body).to eq(
          {
            currentAllocation: {
              id: nil
            }
          }.to_json
        )
      end
    end
  end
end
