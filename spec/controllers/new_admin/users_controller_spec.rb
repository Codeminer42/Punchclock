# frozen_string_literal: true

require 'rails_helper'

describe NewAdmin::UsersController do
  render_views

  let(:user) { create(:user, name: "Jorge").decorate }
  let(:page) { Capybara::Node::Simple.new(response.body) }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    let!(:allocation) { create(:allocation,
                                start_at: 2.months.after,
                                end_at: 3.months.after,
                                user: user,
                                ongoing: true) }


    it 'returns successful status' do
      get :show, params: { id: user.id }

      expect(response).to have_http_status(:ok)
    end

    it 'return the users information' do
      get :show, params: { id: user.id }

      expect(page).to have_content(user.name)
                  .and have_content(user.email)
                  .and have_content(user.otp_required_for_login)
                  .and have_content(user.github)
                  .and have_content(user.office_city)
    end
  end

  describe 'GET #show allocations' do 

    let!(:allocation) { create(:allocation,
      start_at: 2.months.after,
      end_at: 3.months.after,
      user: user,
      ongoing: true) 
    }

    context 'when user is not currently allocated' do 
      it 'shows allocations details with no allocation for user' do 
        get :show, params: { id: user.id }
        click_button('Alocações')
        expect(page).to have_content('Alocação atual') 
                    .and have_content('Não alocado')
      end 
    end 

    context 'when user is currently allocated' do 
      it 'shows the project name where user is allocated' do 
        get :show, params: { id: user.id }
        click_on('Alocações')
        expect(page).to have_content('Alocação atual')
                    .and have_content(allocation.project_name)
      end 
    end   

    context 'when user has allocations' do 
      it 'shows the allocations table with user allocations' do 
        get :show, params: { id: user.id }
        click_on('Alocações')
        expect(page).to have_table('allocations_table', options {
                                    :with_cols ['NOME DO PROJETO', 'INÍCIO', 'TÉRMINO', 'EM PROGRESSO']
                                  })
                    .and have_content(allocation.ongoing)
      end 
    end 

  end 
end
