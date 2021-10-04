require 'spec_helper'

RSpec.describe Admin::ContributionsController, type: :controller do
  render_views

  let(:admin) { build_stubbed(:user, :super_admin) }
  let(:contribution) { build_stubbed(:contribution) }
  let(:page) { Capybara::Node::Simple.new(response.body) } 

  let(:invalid_attributes) do
    { first_name: '' }
  end


  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(admin)
  end
 
  describe 'GET index' do 
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

  describe 'GET new' do
    before do
      get :new
    end

    it 'has http status 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns the contribution' do
      expect(assigns(:contribution)).to be_a_new(Contribution)
    end

    it 'renders the form elements' do
      expect(page).to have_field('contribution[user_id]')
                  .and have_field('contribution[company_id]')
                  .and have_field('contribution[repository_id]')
                  .and have_field('contribution[link]')
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }
    let(:company) { create(:company) }
    let(:repository) { create(:repository) }

    let(:contribution_params) do
      {
        "link"=>"https://github.com/Codeminer", 
        "user_id"=>user.id, 
        "company_id"=>company.id,
        "repository_id"=>repository.id
      }
    end

    context 'with valid params' do
      it 'creates a new Contribution' do
        
        expect {
          post :create, params: { contribution: contribution_params }
        }.to change(Contribution, :count).by(1)
      end

      it 'assigns a newly created contribution as @contribution' do
        post :create, params: { contribution: contribution_params }
        expect(assigns(:contribution)).to be_a(Contribution)
                                      .and be_persisted
      end

      it 'redirects to the created contribution' do
        post :create, params: { contribution: contribution_params }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_contribution_path(Contribution.last))
      end

      it 'should create the contribution' do
        post :create, params: { contribution: contribution_params }
        contribution = Contribution.last

        expect(contribution.link).to eq(contribution_params['link'])
        expect(contribution.user_id).to  eq(user.id)
        expect(contribution.company_id).to      eq(company.id)
        expect(contribution.repository_id).to      eq(repository.id)
      end
    end

    context 'with invalid params' do
      it 'invalid_attributes return http success' do
        post :create, params: { contribution: invalid_attributes }
        expect(response).to have_http_status(:success)
      end

      it 'assigns a newly created but unsaved contribution as @contribution' do
        post :create, params: { contribution: invalid_attributes }
        expect(assigns(:contribution)).to be_a_new(Contribution)
      end

      it 'invalid_attributes do not create a Contribution' do
        expect do
          post :create, params: { person: invalid_attributes }
        end.not_to change(Contribution, :count)
      end
    end
  end

  describe 'GET show' do
    let(:user) { create(:user) }
    let(:company) { create(:company) }
    let(:repository) { create(:repository) }
    let(:contribution_to_show) { create(:contribution, company_id: company.id, user_id: user.id, repository_id: repository.id, link: contribution[:link]) }

    it 'returns http success' do
      get :show, params: { id: contribution_to_show.id }
      expect(response).to have_http_status(:success)
    end
    
    it 'renders the form elements' do
      get :show, params: { id: contribution_to_show.id }
      expect(page).to have_content(contribution_to_show.user)
                  .and have_content(contribution_to_show.company)
                  .and have_content(contribution_to_show.link)
                  .and have_content(Contribution.human_attribute_name("state/#{contribution_to_show.state}"))
    end 
  end
end
