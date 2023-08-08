# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::Projects::AllocateUsersController, type: :controller do
  describe 'GET #new' do
    let(:project) { create(:project) }

    context 'when user is signed in' do
      before do
        sign_in user
        get :new, params: { allocation: { project_id: project.id } }
      end

      context 'when user is authorized' do
        let(:user) { create(:user, :admin) }

        it { is_expected.to respond_with(:ok) }

        it 'renders new template' do
          expect(response).to render_template(:new)
        end

        it 'assigns project passed by query params to @project' do
          expect(assigns(:project)).to be_an_instance_of(Project)
        end

        it 'assigns allocation to @allocation' do
          expect(assigns(:allocation)).to be_an_instance_of(Allocation)
        end
      end

      context 'when the user is not authorized' do
        let(:user) { create(:user) }

        it 'redirects to the root path' do
          get :new, params: { allocation: { project_id: project.id } }

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to sign in path' do
        get :new, params: { allocation: { project_id: project.id } }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    let(:project) { create(:project) }

    context 'when user is signed in' do
      before do
        sign_in user
      end

      context 'when user is authorized' do
        let(:user) { create(:user, :admin) }

        describe 'response validations' do
          before do
            post :create, params: { allocation: { project_id: project.id, user_id: user.id, start_at: '2023-01-01',
                                                  end_at: '2023-12-01' } }
          end

          it { is_expected.to redirect_to new_admin_user_allocation_path(Allocation.last) }

          it 'assigns project passed by query params to @project' do
            expect(assigns(:project)).to be_an_instance_of(Project)
          end

          it 'assigns allocation to @allocation' do
            expect(assigns(:allocation)).to be_an_instance_of(Allocation)
          end

          it 'associates allocation to project' do
            expect(Allocation.last.reload.project).to eq(project)
          end

          it 'associates allocation to user' do
            expect(Allocation.last.reload.user).to eq(user)
          end
        end

        describe 'record validations' do
          it 'creates a new allocation' do
            expect do
              post :create, params: { allocation: { project_id: project.id, user_id: user.id, start_at: '2023-01-01',
                                                    end_at: '2023-12-01' } }
            end.to change(Allocation, :count).from(0).to(1)
          end
        end
      end

      context 'when the user is not authorized' do
        let(:user) { create(:user) }

        it 'redirects to the root path' do
          post :create, params: { allocation: { project_id: project.id } }

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to sign in path' do
        post :create, params: { allocation: { project_id: project.id } }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
