require 'rails_helper'

RSpec.describe RepositoriesController, type: :controller do
  let(:user) { build_stubbed(:user) }
  
  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end
  
  describe 'GET index' do
    let(:repository) { create(:repository, company_id: user.company_id) }
    
    before do
      get :index
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'has http status 200' do
      expect(response).to have_http_status(:ok)
    end
  end
end
