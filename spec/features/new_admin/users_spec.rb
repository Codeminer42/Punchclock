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
      expect(page).to have_content('Não alocado')
    end 
  end 

  context 'when user has allocations' do 

    let!(:allocation) { create(:allocation,
      start_at: 2.months.after,
      end_at: 3.months.after,
      user: user,
      ongoing: true) 
    }

    it 'shows allocations details with user current allocation', js: true do 
      visit "/new_admin/users/#{user.id}"
      click_button('Alocações')
      expect(page).to have_content('ALOCAÇÃO ATUAL')
      expect(page).to have_content(allocation.project_name)
    end 
  end 
end 
