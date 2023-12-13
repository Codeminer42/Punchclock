require 'rails_helper'

RSpec.describe NewAdmin::SkillsController, type: :request do
  describe 'GET #index' do
    context 'when user is signed in' do
      context 'when user is admin' do
        let(:user) { create(:user, :admin) }
        before { sign_in user }

        context 'when no filters are applied' do
          let!(:skills) { create_list(:skill, 2) }

          it 'returns status code 200 ok' do
            get new_admin_skills_path

            expect(response).to have_http_status(:ok)
          end

          it 'renders the index template' do
            get new_admin_skills_path

            expect(response).to render_template(:index)
          end

          it 'shows the skills' do
            get new_admin_skills_path

            expect(response.body).to include(skills[0].title)
              .and include(skills[1].title)
          end
        end

        context 'when title filter is applied' do
          let!(:foo_skill) { create(:skill, title: 'Foo') }
          let!(:bar_skill) { create(:skill, title: 'Bar') }

          it 'returns only the filtered skills', :aggregate_failures do
            get new_admin_skills_path, params: { title: 'foo' }

            expect(response.body).to include('Foo')
            expect(response.body).not_to include('Bar')
          end
        end

        context 'when pagination is applied' do
          let!(:skills_list) { create_list(:skill, 3) }

          it 'paginates the results', :aggregate_failures do
            get new_admin_skills_path, params: { per: 2 }

            expect(assigns(:skills).count).to eq(2)
          end
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to the sign in page' do
        get new_admin_skills_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }

      before { sign_in user }

      it 'redirects to root page' do
        get new_admin_skills_path

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #show' do
  let(:skill) { create(:skill) }

  context 'when user is signed in' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin) }
      before { sign_in user }

      it 'renders the show template' do
        get new_admin_show_skill_path(skill.id)

        expect(response).to render_template(:show)
      end

      it 'renders the correct skill' do
        get new_admin_show_skill_path(skill.id)

        expect(response.body).to include(skill.title)
          .and include(I18n.l(skill.created_at, format: :short))
          .and include(I18n.l(skill.updated_at, format: :short))
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }
      let(:skill) { create(:skill) }
      before { sign_in user }

      it 'redirects to root page' do
        get new_admin_show_skill_path(skill.id)

        expect(response).to redirect_to(root_path)
      end
    end
  end
  context 'when user is not logged in' do
    let(:skill) { create(:skill) }

    it 'redirects to sign in page' do
      get new_admin_show_skill_url(skill.id)

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
end
