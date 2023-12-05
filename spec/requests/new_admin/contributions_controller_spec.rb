require 'rails_helper'

RSpec.describe NewAdmin::ContributionsController, type: :request do
  describe 'GET #index' do
    context 'when user is signed in' do
      context 'when user is admin' do
        let(:user) { create(:user, :admin) }
        before { sign_in user }

        context 'when no filters are applied' do
          let!(:first_contribution) { create(:contribution, :with_users) }
          let!(:second_contribution) { create(:contribution, :with_users) }

          it 'returns status code 200 ok' do
            get new_admin_contributions_path

            expect(response).to have_http_status(:ok)
          end

          it 'renders the index template' do
            get new_admin_contributions_path

            expect(response).to render_template(:index)
          end

          it 'shows the contributions' do
            get new_admin_contributions_path

            expect(response.body).to include(first_contribution.link)
              .and include(second_contribution.link)
          end
        end

        context 'when user is inactive' do
          let!(:inactive_user) { create(:user, :inactive_user) }
          let!(:contribution) { create(:contribution, user_id: inactive_user.id) }

          it 'does not show the contribution' do
            get new_admin_contributions_path

            expect(response.body).not_to include(contribution.link)
          end
        end

        context 'when title filter is applied' do
          let!(:foo_questionnaire) { create(:questionnaire, title: 'Foo') }
          let!(:bar_questionnaire) { create(:questionnaire, title: 'Bar') }

          xit 'returns only the filtered questionnaires', :aggregate_failures do
            get new_admin_questionnaires_path, params: { title: 'foo' }

            expect(response.body).to include('Foo')
            expect(response.body).not_to include('Bar')
          end
        end

        context 'when pagination is applied' do
          let!(:questionnaires_list) { create_list(:questionnaire, 3) }

          xit 'paginates the results', :aggregate_failures do
            get new_admin_questionnaires_path, params: { per: 2 }

            expect(assigns(:questionnaires).count).to eq(2)
          end
        end
      end
    end

    context 'when user is not signed in' do
      it 'redirects to the sign in page' do
        get new_admin_contributions_path

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }

      before { sign_in user }

      it 'redirects to root page' do
        get new_admin_contributions_path

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
