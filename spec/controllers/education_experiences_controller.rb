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

        it 'renders the table with a list of education experiences' do
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
          get :index, params: { per: 1, page: 1 }

          expect(assigns(:education_experiences).count).to eq(1)
        end

        it 'decorates education experiences' do
          get :index, params: { per: 1 }

          expect(assigns(:education_experiences).last).to be_an_instance_of(EducationExperiencePaginationDecorator)
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
end
