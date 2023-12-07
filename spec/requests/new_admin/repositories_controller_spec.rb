# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::RepositoriesController, type: :request do
  describe 'GET #index' do
    let(:repositories) { create_list(:repository, 2) }

    context 'when user is signed in' do

      context 'when user is admin' do
        let(:user) { create(:user, :admin) }

        before do
          sign_in user
          get new_admin_repositories_path
        end

        it 'renders index template' do
          expect(response).to render_template(:index)
        end

        context 'when pagination is applied' do
          let!(:repositories) { create_list(:repository, 3) }

          it 'paginates results' do
            get new_admin_repositories_path, params: { per: 2, page: 2 }
            expect(assigns(:repositories).count).to eq(1)
          end
        end
      end

      context 'when the user is not authorized' do
        let(:user) { create(:user) }

        before { sign_in user }

        it 'redirects to the root path' do
          get new_admin_repositories_path

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'redirects to sign in path' do
        get new_admin_repositories_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #show' do
    let(:repository) { create(:repository) }

    context 'when user is admin' do
      let(:user) { create(:user, :admin) }
      before { sign_in user }

      it 'renders the show template' do
        get new_admin_show_repository_url(repository.id)

        expect(response).to render_template(:show)
      end

      it 'renders the correct repository' do
        get new_admin_show_repository_url(repository.id)

        expect(response.body).to include(repository.link)
          .and include(repository.description)
          .and include(repository.language)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }
      let(:repository) { create(:repository) }
      before { sign_in user }

      it 'redirects to root page' do
        get new_admin_show_repository_url(repository.id)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not logged in' do
      let(:repository) { create(:repository) }

      it 'redirects to sign in page' do
        get new_admin_show_repository_url(repository.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #new' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin) }
      before { sign_in user }

      it 'renders new template' do
        get new_new_admin_repository_path

        expect(response).to render_template(:new)
      end

      it 'returns http status 200 ok' do
        get new_new_admin_repository_path

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }

      before { sign_in user }

      it 'redirects to root page' do
        get new_new_admin_repository_path

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin) }
      before { sign_in user }

      context 'with valid parameters' do
        let(:valid_params) do
          { link: 'https://github.com/Codeminer42/Punchclock', language: 'Ruby', highlight: true, description: 'Some description' }
        end

        it 'creates a new repository' do
          expect { post new_admin_repositories_path, params: { repository: valid_params } }.to change(Repository, :count).by(1)
        end

        it 'redirects to repositories index page' do
          post new_admin_repositories_path, params: { repository: valid_params }
          expect(response).to redirect_to(new_admin_repositories_path)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) { { link: '' } }
        it 'does not create the repository' do
          expect { post new_admin_repositories_path, params: { repository: invalid_params } }.not_to change(Repository, :count)
        end

        it 'renders template new' do
          post new_admin_repositories_path, params: { repository: invalid_params }
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'GET #edit' do
    let(:repository) { create(:repository) }

    context 'when user is admin' do
      let(:user) { create(:user, :admin) }

      before { sign_in user }

      it 'renders edit template' do
        get edit_new_admin_repository_path(repository.id)

        expect(response).to render_template(:edit)
      end

      it 'returns http status 200 ok' do
        get edit_new_admin_repository_path(repository.id)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }

      before { sign_in user }

      it 'redirects to root page' do
        get edit_new_admin_repository_path(repository.id)

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PUT/PATCH #update' do
    let(:repository) { create(:repository) }

    context 'when user is admin' do
      let(:user) { create(:user, :admin) }
      before { sign_in user }

      context 'with valid parameters' do
        let(:valid_params) do
          {
            repository: {
              link: 'https://github.com/Codeminer42/Punchclock2'
            }
          }
        end

        it 'updates the repository' do
          expect do
            put new_admin_update_repository_path(repository.id), params: valid_params
          end.to change { repository.reload.link }.to('https://github.com/Codeminer42/Punchclock2')
        end

        it 'redirects to repository show page' do
          put new_admin_update_repository_path(repository.id), params: valid_params
          expect(response).to redirect_to(new_admin_show_repository_url(repository.id))
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) do
          {
            repository: {
              link: ''
            }
          }
        end

        it 'does not update the repository' do
          expect do
            put new_admin_update_repository_path(repository.id), params: invalid_params
          end.not_to change { repository.reload.link }
        end
      end
    end
  end

  describe 'DELETE #delete' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin) }

      before { sign_in user }

      let!(:repository) { create(:repository) }

      it 'deletes the repository' do
        expect { delete new_admin_destroy_repository_path(repository.id) }.to change(Repository, :count).by(-1)
      end

      it 'redirects to repositories index' do
        delete new_admin_destroy_repository_path(repository.id)

        expect(response).to redirect_to(new_admin_repositories_path)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }
      let!(:repository) { create(:repository) }

      before { sign_in user }

      it 'redirects to root path' do
        delete new_admin_destroy_repository_path(repository.id)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user is not signed in' do
      let!(:repository) { create(:repository) }

      it 'redirects to sign in path' do
        delete new_admin_destroy_repository_path(repository.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
