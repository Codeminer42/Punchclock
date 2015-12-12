require 'spec_helper'

describe CompanyController do
  let(:is_admin) { true }
  let(:user) { create :user, is_admin: is_admin }
  let(:company) { user.company }
  before { login user }

  describe 'PUT update' do
    before do
      allow_any_instance_of(Company).to receive(:update)
      allow_any_instance_of(Company).to receive(:errors).and_return(errors)
      put :update, id: company.id, company: { name: '' }
    end

    context 'when has valid params' do
      let(:errors) { [] }
      it 'should update the company settings' do
        expect(response).to redirect_to root_url
      end
    end

    context 'when has no valid params' do
      let(:errors) { [:invalid] }
      it 'should not update company settings' do
        expect(response).to render_template :edit
      end
    end

    context 'when is not admin' do
      let(:is_admin) { false }
      let(:errors) { [] }
      it 'redirects to root path' do
        expect(response).to redirect_to root_url
      end
    end
  end
end
