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
end
