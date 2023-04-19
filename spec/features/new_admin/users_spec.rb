require 'rails_helper'

describe 'Users', type: :feature do

  let(:user) { create(:user, name: "Jorge").decorate }
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let!(:allocation) { create(:allocation,
                      start_at: 2.months.after,
                      end_at: 3.months.after,
                      user: user,
                      ongoing: true) 
                    }

  before do 
    sign_in(admin_user)
    visit "/new_admin/users/#{user.id}"
  end 

  it 'shows allocations details with no allocation for user' do 
    click_button 'Alocações'
    expect(page).to have_content('Alocação atual') 
  end 
end 
