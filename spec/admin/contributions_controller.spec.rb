require 'spec_helper'

RSpec.describe Admin::ContributionsController, type: :controller do
  render_views

  let(:admin) { build_stubbed(:user, :admin) }
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
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'has http status 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET new' do
    it 'has http status 200' do
      get :new
      expect(response).to have_http_status(:ok)
    end

    it 'assigns the contribution' do
      get :new
      expect(assigns(:contribution)).to be_a_new(Contribution)
    end

    it 'renders the form elements' do
      get :new
      expect(page).to have_field('contribution[user_id]')
                  .and have_field('contribution[repository_id]')
                  .and have_field('contribution[link]')
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }
    let(:repository) { create(:repository) }

    let(:contribution_params) do
      {
        "link"=>"https://github.com/Codeminer", 
        "user_id"=>user.id, 
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
                        .and redirect_to(admin_contribution_path(Contribution.last))
      end

      it 'ensures created contibution received correct link' do
        post :create, params: { contribution: contribution_params }
        contribution = Contribution.last

        expect(contribution.link).to eq(contribution_params['link'])
      end

      it 'ensures created contibution received correct user' do
        post :create, params: { contribution: contribution_params }
        contribution = Contribution.last

        expect(contribution.user_id).to  eq(user.id)
      end

      it 'ensures created contibution received correct repository' do
        post :create, params: { contribution: contribution_params }
        contribution = Contribution.last

        expect(contribution.repository_id).to eq(repository.id)
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
    let(:repository) { create(:repository) }
    let(:contribution_to_show) { create(:contribution, user_id: user.id, repository_id: repository.id, link: contribution[:link]) }

    it 'returns http success' do
      get :show, params: { id: contribution_to_show.id }
      expect(response).to have_http_status(:success)
    end

    it 'renders the form elements' do
      get :show, params: { id: contribution_to_show.id }
      expect(page).to have_content(contribution_to_show.user)
                  .and have_content(contribution_to_show.link)
                  .and have_content(Contribution.human_attribute_name("state/#{contribution_to_show.state}"))
    end 
  end
end
