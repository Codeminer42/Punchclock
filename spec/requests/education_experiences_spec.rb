# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EducationExperience, type: :request do
  describe 'GET #index' do
    let(:user) { create(:user) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      it 'renders the index template' do
        get education_experiences_path

        expect(response).to render_template(:index)
      end

      it 'has status 200' do
        get education_experiences_path

        expect(response).to have_http_status(:ok)
      end

      context 'when the user does not contain education experiences' do
        it 'renders the table with not found message' do
          get education_experiences_path

          expect(response.body).to include(I18n.t('resumes.education_experience.not_found'))
        end
      end

      context 'when the user has education experiences' do
        let!(:education_experiences) { create_list(:education_experience, 2, user_id: user.id) }
        let!(:other_education_experience) { create(:education_experience, institution: 'strange institution') }

        it 'renders the table with a list of education experiences' do
          get education_experiences_path

          expect(response.body).to include(education_experiences[0].institution)
            .and include(education_experiences[0].course)
            .and include(education_experiences[0].start_date.strftime('%d/%m/%Y'))
            .and include(education_experiences[0].end_date.strftime('%d/%m/%Y'))
            .and include(education_experiences[1].institution)
            .and include(education_experiences[1].course)
            .and include(education_experiences[1].start_date.strftime('%d/%m/%Y'))
            .and include(education_experiences[1].end_date.strftime('%d/%m/%Y'))
        end

        it 'shows only the logged in user experiences' do
          get education_experiences_path

          expect(response.body).not_to include(other_education_experience.institution)
        end

        it 'paginates results' do
          get education_experiences_path, params: { per: 1, page: 1 }

          expect(assigns(:education_experiences).count).to eq(1)
        end
      end
    end

    context 'when the user is not logged in' do
      it 'redirects the user to the sign in page' do
        get education_experiences_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET new' do
    let(:user) { create(:user) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      it 'has status 200' do
        get new_education_experience_path

        expect(response).to have_http_status(:ok)
      end

      it 'renders the new template' do
        get new_education_experience_path

        expect(response).to render_template(:new)
      end
    end

    context 'when the user is not logged in' do
      it 'redirects the user to the sign in page' do
        get new_education_experience_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST create' do
    let(:user) { create(:user) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      context 'when params are valid' do
        let(:education_experience_valid_params) do
          {
            institution: 'UFF',
            course: 'Computer Science',
            start_date: '10/10/2000',
            end_date: '10/10/2002',
            user_id: user.id
          }
        end

        it 'has 302 status' do
          post education_experiences_path, params: { education_experience: education_experience_valid_params }

          expect(response).to have_http_status(:found)
        end

        it 'creates a new education experience' do
          expect do
            post education_experiences_path, params: { education_experience: education_experience_valid_params }
          end.to change { EducationExperience.where(education_experience_valid_params).count }.by(1)
        end
      end

      context 'when params are invalid' do
        let(:education_experience_invalid_params) do
          {
            institution: 'UFF',
            course: nil,
            start_date: '10/10/2000',
            end_date: '10/10/2002',
            user_id: user.id
          }
        end

        it 'has 200 status' do
          post education_experiences_path, params: { education_experience: education_experience_invalid_params }

          expect(response).to have_http_status(:ok)
        end

        it 'does not create a new education experience' do
          expect do
            post education_experiences_path, params: { education_experience: education_experience_invalid_params }
          end.not_to(change { EducationExperience.count })
        end
      end
    end
  end

  describe 'GET edit' do
    let(:user) { create(:user) }
    let(:education_experience) { create(:education_experience, user_id: user.id) }
    let(:other_experience) { create(:education_experience) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end
      context 'when experience belongs to user' do
        it 'has status 200' do
          get edit_education_experience_path(education_experience.id)

          expect(response).to have_http_status(:ok)
        end

        it 'renders the edit template' do
          get edit_education_experience_path(education_experience.id)

          expect(response).to render_template(:edit)
        end
      end

      context 'when experience does not belong to user' do
        it 'redirects to /404' do
          get edit_education_experience_path(other_experience.id)

          expect(response).to redirect_to('/404')
        end
      end
    end

    context 'when the user is not logged in' do
      it 'redirects the user to the sign in page' do
        get edit_education_experience_path(education_experience.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PUT/PATCH update' do
    let(:user) { create(:user) }
    let(:education_experience) { create(:education_experience, user_id: user.id) }
    let(:other_experience) { create(:education_experience) }

    context 'when the user is logged in' do
      before do
        sign_in user
      end

      context 'when params are valid' do
        let(:education_experience_valid_params) do
          {
            education_experience: {
              course: 'Teste course'
            }
          }
        end

        context 'when experience belongs to signed in user' do
          it 'has 302 status' do
            put education_experience_path(education_experience.id), params: education_experience_valid_params

            expect(response).to have_http_status(:found)
          end

          it 'updates the education experience' do
            expect do
              put education_experience_path(education_experience.id), params: education_experience_valid_params
            end.to change { education_experience.reload.course }.to('Teste course')
          end
        end

        context 'when experience does not belong to signed in user' do
          it 'redirects to /404' do
            put education_experience_path(education_experience.id), params: education_experience_valid_params
          end

          it 'does not update the experience' do
            expect { put education_experience_path(education_experience.id), params: education_experience_valid_params }
              .not_to change(EducationExperience.find(other_experience.id), :course)
          end
        end
      end

      context 'when params are invalid' do
        let(:education_experience_invalid_params) do
          {
            education_experience: {
              course: nil
            }
          }
        end

        it 'has 200 status' do
          put education_experience_path(education_experience.id), params: education_experience_invalid_params

          expect(response).to have_http_status(:ok)
        end

        it 'does not update the education experience' do
          expect do
            put education_experience_path(education_experience.id), params: education_experience_invalid_params
          end.not_to(change { education_experience.reload.course })
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is signed in' do
      let!(:user) { create(:user) }
      let!(:education_experience) { create(:education_experience, user:) }
      let!(:other_experience) { create(:education_experience) }

      before { sign_in user }

      context 'when education experience belongs to signed in user' do
        it 'deletes the education experience' do
          expect { delete education_experience_path(education_experience.id) }.to change(EducationExperience, :count).by(-1)
        end

        it 'redirects to education experiences index' do
          delete education_experience_path(education_experience.id)

          expect(response).to redirect_to(education_experiences_path)
        end
      end

      context 'when education experience does not belong to signed in user' do
        it 'redirects to /404' do
          delete education_experience_path(other_experience.id)

          expect(response).to redirect_to('/404')
        end

        it 'does not delete the experience' do
          expect { delete education_experience_path(other_experience.id) }.not_to change(EducationExperience, :count)
        end
      end
    end

    context 'when user is not signed in' do
      let(:education_experience) { create(:education_experience) }

      it 'redirects to sign in page' do
        delete education_experience_path(education_experience.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
