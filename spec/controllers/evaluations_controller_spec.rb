require 'spec_helper.rb'

describe EvaluationsController, type: :controller do
  let(:reviewer) { create(:user) }

  describe 'GET #index' do
    context 'when logged out' do
      before { get :index }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to(new_user_session_url) }
    end

    context 'when logged in' do
      before do
        sign_in reviewer
        get :index
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:index) }
    end
  end

  describe 'GET #show' do
    context 'when logged out' do
      before { get :show, id: 1 }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to(new_user_session_url) }
    end

    context 'when logged in' do
      let(:evaluation) { create(:evaluation) }

      before do
        sign_in evaluation.reviewer
        get :show, id: evaluation.id
      end

      it 'assigns @evaluation' do
        expect(assigns(:evaluation)).to eq(evaluation)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:show) }
    end
  end

  describe 'GET #new' do
    context 'when logged out' do
      before { get :new }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to(new_user_session_url) }
    end

    context 'when logged in' do
      before do
        sign_in reviewer
        get :new
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:new) }
    end
  end

  describe 'POST #create' do
    context 'when logged out' do
      before { post :create, evaluation: {} }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to(new_user_session_url) }
    end

    context 'when logged in' do
      before { sign_in reviewer }

      let(:user) { create(:user) }

      context 'with valid params' do
        before { post :create, evaluation: { user_id: user.id, review: 'Foobar' } }

        it { expect(response).to have_http_status(:found) }
        it { expect(response).to redirect_to(evaluations_url) }

        it 'should create an evaluation' do
          expect {
            post :create, evaluation: { user_id: user.id, review: 'Foobar' }
          }.to change(Evaluation, :count).by(1)
        end
      end

      context 'with invalid params' do
        before { post :create, evaluation: { user_id: 'abc', review: '' } }

        it { is_expected.to render_template(:new) }

        it 'should not create an evaluation' do
          expect {
            post :create, evaluation: { user_id: 'abc', review: '' }
          }.to change(Evaluation, :count).by(0)
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'when logged out' do
      before { get :edit, id: 1 }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to(new_user_session_url) }
    end

    context 'when logged in' do
      let(:evaluation) { create(:evaluation) }

      before do
        sign_in evaluation.reviewer
        get :edit, id: evaluation.id
      end

      it 'assigns @evaluation' do
        expect(assigns(:evaluation)).to eq(evaluation)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:edit) }
    end
  end

  describe 'PUT #update' do
    context 'when logged out' do
      before { put :update, id: 1 }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to(new_user_session_url) }
    end

    context 'when logged in' do
      let(:evaluation) { create(:evaluation) }
      let(:user) { create(:user) }

      before { sign_in evaluation.reviewer }

      context 'with valid params' do
        before { put :update, id: evaluation.id, evaluation: { review: 'Foobar' } }

        it { expect(response).to have_http_status(:found) }
        it { expect(response).to redirect_to(evaluations_url) }

        it 'should update an evaluation' do
          evaluation.reload
          expect(evaluation.review).to eql('Foobar')
        end
      end

      context 'with invalid params' do
        before { put :update, id: evaluation.id, evaluation: { user_id: 'abc', review: 'Foobar' } }

        it 'should not update an evaluation' do
          evaluation.reload
          expect(evaluation.review).not_to eql('Foobar')
        end

        it { is_expected.to render_template(:edit) }
      end
    end
  end
end
