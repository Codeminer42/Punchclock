# frozen_string_literal: true

require 'rails_helper'

describe NewAdmin::AllocationChartsController do
  render_views

  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET #index' do
    context 'when user is signed in' do
      before do
        sign_in(user)
      end

      context 'when the user is an admin' do
        let(:user) { create(:user, :admin, name: 'João') }

        context 'when there are no allocations' do
          it 'returns a successful status' do
            get :index

            expect(response).to have_http_status(:ok)
          end

          it 'returns users within an empty allocation' do
            get :index

            expect(page).to have_content(user.name)
                        .and have_content(/#{user.specialty}/i)
          end
        end

        context 'when there are active allocations' do
          let!(:allocation) do
            create(:allocation,
                   start_at: 2.months.after,
                   end_at: 3.months.after,
                   user: user,
                   ongoing: true)
          end

          it 'returns a successful status' do
            get :index

            expect(response).to have_http_status(:ok)
          end

          it 'returns allocations' do
            get :index

            expect(page).to have_content(allocation.project_name)
                        .and have_content(user.name)
                        .and have_content(/#{user.specialty}/i)
                        .and have_content(allocation.end_at.strftime('%d/%m/%Y'))
          end
        end

        context 'when number of allocations is enough to paginate the registers' do
          let!(:allocations) { create_list(:allocation, 3) }

          it 'paginates allocations' do
            get :index, params: { per: 2 }

            expect(assigns(:allocations).count).to eq(2)
          end

          it 'decorates allocations' do
            get :index, params: { per: 1 }

            expect(assigns(:allocations).last).to be_an_instance_of(AllocationDecorator)
          end
        end
      end

      context 'when the user is not an admin' do
        let(:user) { create(:user) }

        it 'redirects to root path' do
          get :index

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to the sign in path' do
        get :index

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
