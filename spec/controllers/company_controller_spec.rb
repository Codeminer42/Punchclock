require 'spec_helper'

describe CompanyController do
  login_user

  describe 'PUT update' do
    let(:user) { double('user') }
    let(:company) { FactoryGirl.create(:company) }

    before do
      controller.stub(current_user: user)
    end

    context 'when authorize pass' do
      before do
        Company.stub(:find).with(company.id.to_s) { company }
        controller.stub(authenticate_user!: true)
        controller.stub(load_and_authorize_resource: true)
        user.stub(is_admin?: true)
        user.stub(id: 1)
        user.stub(company: company)
        user.stub(company_id: company.id)
      end

      it 'should update the company settings' do
        params = {
          id: company.id,
          company: { name: '1234' }
        }

        expect(company).to receive(:update).and_return(true)
        put :update, params
        expect(response).to redirect_to root_path
      end

      it 'should not update company settings' do
        params = {
          id: company.id,
          company: { name: '' }
        }

        expect(company).to receive(:update).and_return(false)
        put :update, params
        expect(response).to render_template :edit
      end
    end
  end
end
