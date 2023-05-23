require 'rails_helper'

describe 'Users', type: :feature do

  let(:user) { create(:user, name: "Jorge").decorate }
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do 
    sign_in(admin_user)
    visit "/new_admin/users/#{user.id}"
  end 

  context 'when user is not allocated' do 
    
    it 'shows allocations details with no allocation for user', js: true do 
      click_button('Alocações')
      expect(page).to have_content('ALOCAÇÃO ATUAL')
      expect(page).to have_content('Não Alocado')
    end 
  end 

  context 'when user has allocations' do 

    let!(:allocation) { 
      create(
        :allocation,
        start_at: 2.months.after,
        end_at: 3.months.after,
        user: user,
        ongoing: true
      ) 
    }

    let!(:another_allocation) { 
      create(
        :allocation,
        start_at: 6.months.before, 
        end_at: 1.month.before,
        user: user, 
        ongoing: false
      )
    }

    it 'shows allocations details with user current allocation', js: true do 
      visit "/new_admin/users/#{user.id}"
      click_button('Alocações')
      expect(page).to have_content('ALOCAÇÃO ATUAL') && 
        have_content(allocation.project_name)
    end 

    it 'shows table of allocations', js: true do 
      visit "/new_admin/users/#{user.id}"
      click_button('Alocações')
      expect(page).to have_table("allocations_table") &&
        have_content(another_allocation.project_name) &&
        have_content("#{l(another_allocation.start_at)}") &&
        have_content("#{l(another_allocation.end_at)}") &&
        have_content("#{I18n.t(another_allocation.ongoing)}") &&
        have_content('Acessar Alocação') &&
        have_content('ALOCAÇÃO ATUAL') &&
        have_content(allocation.project_name)
    end 
  end 
end 
