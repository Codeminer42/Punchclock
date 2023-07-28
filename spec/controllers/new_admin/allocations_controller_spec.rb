# frozen_string_literal: true

require 'rails_helper'

describe NewAdmin::AllocationsController do
  render_views

  let(:user) { create(:user, name: 'Jorge').decorate }
  let!(:allocation) do
    create(:allocation,
           start_at: 2.months.after,
           end_at: 3.months.after,
           user: user,
           ongoing: true).decorate
  end

  let(:allocation_forecast) { RevenueForecastService.allocation_forecast(allocation) }
  let(:page) { Capybara::Node::Simple.new(response.body) }

  describe 'GET #show' do
    context 'when the user is signed in' do
      before do
        sign_in(user)
      end

      context 'when the user is an admin' do
        let(:user) { create(:user, :admin, name: 'Jorge').decorate }

        it 'returns a successful status' do
          get :show, params: { id: allocation.id }

          expect(response).to have_http_status(:ok)
        end

        it 'returns the allocation' do
          get :show, params: { id: allocation.id }

          expect(page).to have_content(allocation.project_name)
                      .and have_content(user.name)
                      .and have_content(I18n.l(allocation.start_at))
                      .and have_content(I18n.l(allocation.end_at))
                      .and have_content(allocation.hourly_rate)
                      .and have_content(allocation.ongoing)
                      .and have_content(allocation.days_left)
        end

        it 'returns the allocation forecast' do
          get :show, params: { id: allocation.id }

          expect(page).to have_content(I18n.l(allocation.end_at, format: :short))
                      .and have_content(allocation_forecast.first[:working_hours])
        end
      end

      context 'when the user is not an admin' do
        it 'redirects to the root path' do
          get :show, params: { id: allocation.id }

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to the sign in path' do
        get :show, params: { id: allocation.id }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'when the user is signed in' do
      before do
        sign_in(user)
      end

      context 'when the user is an admin' do
        let(:user) { create(:user, :admin, name: 'Jorge').decorate }

        it 'returns the allocation' do
          get :edit, params: { id: allocation.id }

          expect(subject.instance_variable_get(:@allocation)).to eq(allocation)
        end

        it 'renders edit template' do
          get :edit, params: { id: allocation.id }

          expect(response).to render_template :edit
        end
      end

      context 'when the user is not an admin' do
        it 'redirects to the root path' do
          get :edit, params: { id: allocation.id }

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to the sign in path' do
        get :edit, params: { id: allocation.id }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:allocation_attributes) { { hourly_rate_cents: 2.41 } }

    context 'when the user is signed in' do
      before do
        sign_in(user)
      end

      context 'when the user is an admin' do
        let(:user) { create(:user, :admin, name: 'Jorge').decorate }

        context 'with valid allocation attributes' do
          it 'updates the allocation' do
            patch :update, params: { id: allocation.id, allocation: allocation_attributes }

            expect(subject.instance_variable_get(:@allocation)).to have_attributes(hourly_rate_cents: allocation_attributes[:hourly_rate_cents] * 100)
          end

          it 'redirects to allocation details path' do
            patch :update, params: { id: allocation.id, allocation: allocation_attributes }

            expect(response).to redirect_to new_admin_user_allocation_path
          end
        end

        context 'with invalid allocation attributes' do
          let(:allocation_attributes) { { start_at: 4.months.after } }

          it 'renders edit template' do
            patch :update, params: { id: allocation.id, allocation: allocation_attributes }

            expect(response).to redirect_to edit_new_admin_user_allocation_path
          end
        end
      end

      context 'when the user is not an admin' do
        it 'redirects to the root path' do
          patch :update, params: { id: allocation.id, allocation: allocation_attributes }

          expect(response).to redirect_to(root_path)
        end

        it 'does not update the allocation' do
          expect { patch :update, params: { id: allocation.id, allocation: allocation_attributes } }
            .not_to(change { allocation.reload })
        end
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to the sign in path' do
        patch :update, params: { id: allocation.id, allocation: allocation_attributes }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
