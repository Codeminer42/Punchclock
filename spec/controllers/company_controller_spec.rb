require 'spec_helper'

describe CompanyController do
  let(:user) { create :user, is_admin: true }
  let(:company) { user.company }
  before { login user }

  describe 'PUT update' do
    before do
      Company.any_instance.stub(:update)
        .with(any_args).and_return(has_valid_params)
      put :update, id: company.id, company: { name: '' }
    end

    context 'when has valid params' do
      let(:has_valid_params) { true }
      it 'should update the company settings' do
        expect(response).to redirect_to root_url
      end
    end

    context 'when has no valid params' do
      let(:has_valid_params) { false }
      it 'should not update company settings' do
        expect(response).to render_template :edit
      end
    end
  end
end
