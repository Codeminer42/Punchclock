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
end
