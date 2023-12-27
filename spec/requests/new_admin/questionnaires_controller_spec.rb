require 'rails_helper'

RSpec.describe NewAdmin::QuestionnairesController, type: :request do
  describe 'GET #index' do
    context 'when user is signed in' do
      context 'when user is admin' do
        let(:user) { create(:user, :admin) }
        before { sign_in user }

        context 'when no filters are applied' do
          let!(:questionnaires) { create_list(:questionnaire, 2) }

          it 'returns status code 200 ok' do
            get new_admin_questionnaires_path

            expect(response).to have_http_status(:ok)
          end

          it 'renders the index template' do
            get new_admin_questionnaires_path

            expect(response).to render_template(:index)
          end

          it 'shows the questionnaires' do
            get new_admin_questionnaires_path

            expect(response.body).to include(questionnaires[0].title)
              .and include(questionnaires[1].title)
          end
        end

        context 'when title filter is applied' do
          let!(:foo_questionnaire) { create(:questionnaire, title: 'Foo') }
          let!(:bar_questionnaire) { create(:questionnaire, title: 'Weird title') }

          it 'returns only the filtered questionnaires', :aggregate_failures do
            get new_admin_questionnaires_path, params: { title: 'foo' }

            expect(response.body).to include('Foo')
            expect(response.body).not_to include('Weird title')
          end
        end

        context 'when pagination is applied' do
          let!(:questionnaires_list) { create_list(:questionnaire, 3) }

          it 'paginates the results', :aggregate_failures do
            get new_admin_questionnaires_path, params: { per: 2 }

            expect(assigns(:questionnaires).count).to eq(2)
          end
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to the sign in page' do
        get new_admin_questionnaires_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }

      before { sign_in user }

      it 'redirects to root page' do
        get new_admin_questionnaires_path

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #new' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin) }
      before { sign_in user }

      it 'renders new template' do
        get new_new_admin_questionnaire_path

        expect(response).to render_template(:new)
      end

      it 'returns http status 200 ok' do
        get new_new_admin_questionnaire_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }

      before { sign_in user }

      it 'redirects to root page' do
        get new_new_admin_questionnaire_path

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #show' do
    let(:questionnaire) { create(:questionnaire) }

    context 'when user is admin' do
      let(:user) { create(:user, :admin) }
      before { sign_in user }

      it 'renders the show template' do
        get new_admin_show_questionnaire_url(questionnaire.id)

        expect(response).to render_template(:show)
      end

      it 'renders the correct questionnaire' do
        get new_admin_show_questionnaire_url(questionnaire.id)

        expect(response.body).to include(questionnaire.title)
          .and include(questionnaire.description)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }
      let(:questionnaire) { create(:questionnaire) }
      before { sign_in user }

      it 'redirects to root page' do
        get new_admin_show_questionnaire_url(questionnaire.id)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      let(:questionnaire) { create(:questionnaire) }

      it 'redirects to sign in page' do
        get new_admin_show_questionnaire_url(questionnaire.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin) }
      before { sign_in user }

      context 'with valid parameters' do
        let(:valid_params) do
          { title: 'title', kind: 'english', active: true, description: 'some description', questions_attributes:
        { '0' => { title: 'some title', kind: 'multiple_choice', raw_answer_options: 'one;two;three' } } }
        end
        it 'creates a new questionnaire' do
          expect { post new_admin_questionnaires_path, params: { questionnaire: valid_params } }.to change(Questionnaire, :count).by(1)
        end

        it 'creates a new question' do
          expect { post new_admin_questionnaires_path, params: { questionnaire: valid_params } }.to change(Question, :count).by(1)
        end

        it 'redirects to questionnaires index page' do
          post new_admin_questionnaires_path, params: { questionnaire: valid_params }
          expect(response).to redirect_to(new_admin_questionnaires_path)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) { { title: '' } }
        it 'does not create the questionnaire' do
          expect { post new_admin_questionnaires_path, params: { questionnaire: invalid_params } }.not_to change(Questionnaire, :count)
        end

        it 'does not create questions' do
          expect { post new_admin_questionnaires_path, params: { questionnaire: invalid_params } }.not_to change(Question, :count)
        end

        it 'renders template new' do
          post new_admin_questionnaires_path, params: { questionnaire: invalid_params }
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin) }
      let(:questionnaire) { create(:questionnaire) }
      before { sign_in user }

      it 'renders edit template' do
        get edit_new_admin_questionnaire_path(questionnaire.id)

        expect(response).to render_template(:edit)
      end

      it 'returns http status 200 ok' do
        get edit_new_admin_questionnaire_path(questionnaire.id)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }
      let(:questionnaire) { create(:questionnaire) }

      before { sign_in user }

      it 'redirects to root page' do
        get edit_new_admin_questionnaire_path(questionnaire.id)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      let(:questionnaire) { create(:questionnaire) }

      it 'redirects to root path' do
        get edit_new_admin_questionnaire_path(questionnaire.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin) }
      let(:questionnaire) { create(:questionnaire) }

      before { sign_in user }

      context 'whith valid params' do
        let(:valid_params) { { questionnaire: { title: 'New title' } } }
        it 'updates the questionnaire' do
          patch new_admin_update_questionnaire_path(questionnaire.id, params: valid_params)

          expect(questionnaire.reload.title).to eq('New title')
        end

        it 'redirects to show page' do
          patch new_admin_update_questionnaire_path(questionnaire.id, params: valid_params)

          expect(response).to redirect_to(new_admin_show_questionnaire_path)
        end
      end

      context 'with invalid params' do
        let(:invalid_params) { { questionnaire: { title: '' } } }

        it 'does not update the questionnaire' do
          expect { patch new_admin_update_questionnaire_path(questionnaire.id, params: invalid_params) }.not_to change(Questionnaire.find(questionnaire.id), :title)
        end

        it 'renders the edit template with errors', :aggregate_failures do
          patch new_admin_update_questionnaire_path(questionnaire.id, params: invalid_params)

          expect(response.body).to include('Título não pode ficar em branco')
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }
      let(:questionnaire) { create(:questionnaire) }
      let(:valid_params) { { questionnaire: { title: 'New title' } } }

      before { sign_in user }

      it 'redirects to root path' do
        patch new_admin_update_questionnaire_path(questionnaire.id, params: valid_params)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      let(:questionnaire) { create(:questionnaire) }
      let(:valid_params) { { questionnaire: { title: 'New title' } } }

      it 'redirects to root path' do
        patch new_admin_update_questionnaire_path(questionnaire.id, params: valid_params)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #delete' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin) }

      before { sign_in user }

      let!(:questionnaire) { create(:questionnaire) }

      it 'deletes the questionnaire' do
        expect { delete new_admin_destroy_questionnaire_path(questionnaire.id) }.to change(Questionnaire, :count).by(-1)
      end

      it 'redirects to questionnaires index' do
        delete new_admin_destroy_questionnaire_path(questionnaire.id)

        expect(response).to redirect_to(new_admin_questionnaires_path)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }
      let(:questionnaire) { create(:questionnaire) }

      before { sign_in user }

      it 'redirects to root path' do
        delete new_admin_destroy_questionnaire_path(questionnaire.id)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user not logged in' do
      let(:questionnaire) { create(:questionnaire) }

      it 'redirects to root path' do
        delete new_admin_destroy_questionnaire_path(questionnaire.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
