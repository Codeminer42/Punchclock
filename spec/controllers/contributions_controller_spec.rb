# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContributionsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let!(:contribution_list) do
    [
      create(:contribution, user:, created_at: 10.days.ago, state: :approved),
      create(:contribution, user:, created_at: Date.today, state: :approved),
      create(:contribution, user:, created_at: Date.today, state: :refused, rejected_reason: :other_reason)
    ]
  end
  let(:page) { Capybara::Node::Simple.new(response.body) }

  context 'when the user is logged in' do
    before do
      sign_in(user)
    end

    describe 'GET index' do
      it 'renders the index template' do
        get :index

        expect(response).to render_template(:index)
      end

      it 'has status 200' do
        get :index

        expect(response).to have_http_status(:ok)
      end

      context 'when the user does not contain contributions' do
        let(:contribution_list) { [] }

        it 'renders the table with not found message' do
          get :index

          expect(page.find('table')).to have_content(I18n.t('contributions.no_prs_found'))
        end
      end

      context 'when the user contains contributions' do
        it 'renders the table with a list of contributions' do
          get :index

          expect(page.find('table')).to have_content(contribution_list[0].link)
                                    .and have_content(contribution_list[0].pr_state_text)
                                    .and have_content(contribution_list[0].created_at.strftime('%d/%m/%Y'))
                                    .and have_selector(:css, "a[href='/contributions/#{contribution_list[0].id}/edit']")
                                    .and have_content(contribution_list[1].link)
                                    .and have_content(contribution_list[1].pr_state_text)
                                    .and have_content(contribution_list[1].created_at.strftime('%d/%m/%Y'))
                                    .and have_selector(:css, "a[href='/contributions/#{contribution_list[1].id}/edit']")
        end

        it 'does not show rejected contributions' do
          get :index


          expect(page.find('table')).not_to have_content(contribution_list[2].link)
        end

        it 'returns the newest contributions first' do
          get :index

          expect(assigns(:user_contributions)).to eq([contribution_list[1], contribution_list[0]])
        end
      end
    end

    describe 'GET edit' do
      let(:contribution) { create(:contribution, user: user) }
      let(:params) { { id: contribution.id } }

      context 'when the page is accessed' do
        it 'is expected to return a successful status' do
          get(:edit, params:)

          expect(response).to have_http_status(:ok)
        end

        it 'is expected to render the edit page' do
          get(:edit, params:)

          expect(page.find(:css, '.main'))
            .to have_content('Editando Contribuição')
            .and have_content(contribution.link)
            .and have_field('contribution[description]')
            .and have_selector("input[type='submit']")
        end
      end
    end

    describe 'PUT update' do
      let(:contribution) { create(:contribution, user:) }
      let(:params) do
        {
          id: contribution.id,
          contribution: {
            description:
          }
        }
      end
      let(:description) { nil }

      context 'when description is passed' do
        context 'when description has some content' do
          let(:description) { 'some text' }

          it 'is expected to update the contribution description' do
            expect { put :update, params: }
              .to change { contribution.reload.description }
              .from(nil)
              .to('some text')
          end
        end

        context 'when description is an empty string' do
          let(:contribution) { create(:contribution, user:, description: 'description') }
          let(:description) { '' }

          it 'is expected to update the contribution description with the nil value' do
            expect { put :update, params: }
              .to change { contribution.reload.description }
              .from('description')
              .to(nil)
          end
        end
      end

      context 'when the parameters are valid' do
        let(:description) { 'description' }

        it "is expected to redirect to contribution index page" do
          put(:update, params:)

          expect(response).to redirect_to contributions_path
        end

        it "is expected to flash the successful" do
          put(:update, params:)

          expect(flash[:notice])
            .to eq(
              I18n.t(
                :notice,
                scope: "flash.actions.update",
                resource_name: Contribution.model_name.human
              )
            )
        end
      end
    end
  end

  context 'when the user is not logged in' do
    describe 'GET index' do
      it 'redirects the user to the sign in page' do
        get :index

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET edit' do
      let(:contribution) { create(:contribution) }
      let(:params) { { id: contribution.id } }

      it 'redirects the user to the sign in page' do
        get(:edit, params:)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'PUT update' do
      let(:contribution) { create(:contribution) }
      let(:params) { { id: contribution.id } }
      it 'redirects the user to the sign in page' do
        put(:update, params:)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
