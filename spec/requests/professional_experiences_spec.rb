require 'rails_helper'

RSpec.describe ProfessionalExperience, type: :request do
  describe 'GET #index' do
    context 'when user is signed in' do
      let!(:user) { create(:user) }
      let!(:user_experience) { create(:professional_experience, user:) }
      let!(:other_experience) { create(:professional_experience) }

      before { sign_in user }

      it 'renders the index template' do
        get professional_experiences_path

        expect(response).to render_template(:index)
      end

      it "shows only the user's professional experiences", :aggregate_failures do
        get professional_experiences_path

        expect(response.body).to include(user_experience.company)
        expect(response.body).to include(user_experience.position)
        expect(response.body).not_to include(other_experience.company)
        expect(response.body).not_to include(other_experience.position)
      end

      context 'when pagination is applied' do
        let!(:user_experiences) { create_list(:professional_experience, 3, user:) }

        it 'paginates the results' do
          get professional_experiences_path, params: { per: 2 }
          expect(assigns(:professional_experiences).count).to eq(2)
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to root path' do
        get professional_experiences_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #new' do
    context 'when user is signed in' do
      let(:user) { create(:user) }
      before { sign_in user }

      it 'renders the new template' do
        get new_professional_experience_path

        expect(response).to render_template(:new)
      end
    end

    context 'when user is not signed in' do
      it 'redirects to sign in page' do
        get new_professional_experience_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is signed in' do
      let(:user) { create(:user) }
      before { sign_in user }

      context 'with valid params' do
        let(:valid_params) do
          { professional_experience: { company: 'Codeminer42', position: 'Software engineer', description: 'some description here', responsibilities: 'Ruby on Rails', start_date: '11/2021',
                                       end_date: '11/2022' } }
        end

        it 'creates a new professional experience' do
          expect { post professional_experiences_path, params: valid_params }.to change(ProfessionalExperience, :count).by(1)
        end

        it 'attaches the professional experience to the signed in user' do
          post professional_experiences_path, params: valid_params

          expect(ProfessionalExperience.last.user).to eq(user)
        end

        it 'redirects to professional_experiences_path' do
          post professional_experiences_path, params: valid_params

          expect(response).to redirect_to(professional_experiences_path)
        end
      end

      context 'with invalid params' do
        let(:invalid_params) { { professional_experience: { company: '', position: '' } } }

        it 'does not create the student' do
          expect { post professional_experiences_path, params: invalid_params }.not_to change(ProfessionalExperience, :count)
        end

        it 'renders the new template' do
          post professional_experiences_path, params: { professional_experience: invalid_params }

          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:user_experience) { create(:professional_experience, user:) }
    let(:other_experience) { create(:professional_experience) }

    context 'when user is logged in' do
      before { sign_in user }
      context 'when professional experience belongs to logged in user' do
        it 'renders the show template' do
          get professional_experience_path(user_experience)

          expect(response).to render_template(:show)
        end
      end

      context 'when professional experience does not exist or does not belong to user' do
        it 'redirects to not found page' do
          get professional_experience_path(other_experience)

          expect(response).to redirect_to('/404')
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        get professional_experience_path(other_experience)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is signed in' do
      let(:user) { create(:user) }
      let(:user_professional_experience) { create(:professional_experience, user:) }
      let(:other_professional_experience) { create(:professional_experience) }

      before { sign_in user }

      context 'when professional experience belongs to signed in user' do
        it 'renders the edit template' do
          get edit_professional_experience_path(user_professional_experience.id)

          expect(response).to render_template(:edit)
        end
      end

      context 'when professional experience does no belong to signed in user' do
        it 'redirects to not found page' do
          get edit_professional_experience_path(other_professional_experience.id)

          expect(response).to redirect_to('/404')
        end
      end
    end

    context 'when user is not signed in' do
      let(:professional_experience) { create(:professional_experience) }
      it 'redirects to sign in page' do
        get edit_professional_experience_path(professional_experience.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
