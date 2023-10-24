# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EducationExperiencesController, type: :controller do
  render_views



  describe 'GET #index' do
    let(:user) { create(:user) }

    let(:page) { Capybara::Node::Simple.new(response.body) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      it 'renders the index template' do
        get :index

        expect(response).to render_template(:index)
      end

      it 'has status 200' do
        get :index

        expect(response).to have_http_status(:ok)
      end

      context 'when the user does not contain education experiences' do
        it 'renders the table with not found message' do
          get :index

          expect(page.find('table')).to have_content(I18n.t('resumes.education_experience.not_found'))
        end
      end

      context 'when the user has educatione experiences' do
        let!(:education_experiences) { create_list(:education_experience, 2, user_id: user.id) }

        it 'renders the table with a list of contributions' do
          get :index

          expect(page.find('table')).to have_content(education_experiences[0].institution)
                                    .and have_content(education_experiences[0].course)
                                    .and have_content(education_experiences[0].start_date.strftime('%d/%m/%Y'))
                                    .and have_content(education_experiences[0].end_date.strftime('%d/%m/%Y'))
                                    .and have_content(education_experiences[1].institution)
                                    .and have_content(education_experiences[1].course)
                                    .and have_content(education_experiences[1].start_date.strftime('%d/%m/%Y'))
                                    .and have_content(education_experiences[1].end_date.strftime('%d/%m/%Y'))
        end

        it 'paginates results' do
          get :index, params: { per: 2, page: 1 }

          expect(assigns(:education_experiences).count).to eq(2)
        end

        it 'decorates regional holidays' do
          get :index, params: { per: 1 }

          expect(assigns(:education_experiences).last).to be_an_instance_of(EducationExperienceDecorator)
        end
      end
    end

    context 'when the user is not logged in' do
      it 'redirects the user to the sign in page' do
        get :index

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET new' do
    let(:user) { create(:user) }

    let(:page) { Capybara::Node::Simple.new(response.body) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      it 'has status 200' do
        get :new

        expect(response).to have_http_status(:ok)
      end

      it 'renders the new template' do
        get :index

        expect(response).to render_template(:new)
      end
    end

    context 'when the user is not logged in' do
      it 'redirects the user to the sign in page' do
        get :index

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST create' 
    let(:user) { create(:user) }
    let(:page) { Capybara::Node::Simple.new(response.body) }
  
    context 'when the user is logged in' do
  
      before do
        sign_in user
      end

      context 'when params are valid' do
        it "saves the user vacation" do
          post :create, params: { vacation: vacation_valid_params }
  
          expect(response).to have_http_status(:found)
        end

      end

      context 'when params are invalid' do

      end
    end

    context 'when the user is not logged in' do
      it 'redirects the user to the sign in page' do
        get :index

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET edit' do
    let(:user) { create(:user) }
    let(:education_experience) { create(:education_experience, user_id: user.id) }

    let(:page) { Capybara::Node::Simple.new(response.body) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      it 'has status 200' do
        get :edit, params: { id: education_experience.id }

        expect(response).to have_http_status(:ok)
      end

      it 'renders the new template' do
        get :edit, params: { id: education_experience.id }

        expect(response).to render_template(:edit)
      end
    end

    context 'when the user is not logged in' do
      it 'redirects the user to the sign in page' do
        get :edit, params: { id: education_experience.id }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST update' do
    let(:user) { create(:user) }
    let(:education_experience) { create(:education_experience, user_id: user.id) }
    let(:page) { Capybara::Node::Simple.new(response.body) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      context 'when params are valid' do
        let(:education_experience_valid_params) do
          {
            course: 'Teste course'
          }
        end

        it 'has 302 status' do
          post :update, params: { id: education_experience.id, education_experience: education_experience_valid_params }

          expect(response).to have_http_status(:found)
        end

        it 'creates a new education experience' do
          expect do
            post :update, params: { id: education_experience.id, education_experience: education_experience_valid_params }
          end.to change { education_experience.reload.course }.to('Teste course')
        end
      end

      context 'when params are invalid' do
        let(:education_experience_invalid_params) do
          {
            course: nil
          }
        end

        it 'has 200 status' do
          post :update, params: { id: education_experience.id, education_experience: education_experience_invalid_params }

          expect(response).to have_http_status(:ok)
        end

        it 'does not create a new education experience' do
          expect do
            post :update, params: { id: education_experience.id, education_experience: education_experience_invalid_params }
          end.not_to(change { education_experience.reload.course })
        end
      end
    end
  end
end
