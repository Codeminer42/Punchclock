require 'rails_helper'

RSpec.describe ContributionsController, type: :controller do
  render_views

  let(:user) { build_stubbed(:user) }
  let(:contribution_list) { [build_stubbed(:contribution), build_stubbed(:contribution)] }
  let(:contribution_model) { double('ActiveRecord', order: contribution_list) }
  let(:page) { Capybara::Node::Simple.new(response.body) }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
    allow(user).to receive(:contributions).and_return(contribution_model)
    allow(contribution_model).to receive(:approved).and_return(contribution_model)
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
                                  .and have_content(contribution_list[1].link)
                                  .and have_content(contribution_list[1].pr_state_text)
                                  .and have_content(contribution_list[1].created_at.strftime('%d/%m/%Y'))
      end
    end
  end
end
