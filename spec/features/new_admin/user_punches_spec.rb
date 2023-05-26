describe 'User Punches', type: :feature do 
  let(:user) { create(:user).decorate }
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do 
    sign_in(admin_user)
    visit "/new_admin/users/#{user.id}"
  end 

  context 'when user has no punches registered' do 
    it 'shows empty punches page', js: true do 
      click_button('Punches')
      expect(page).to have_content("Sem Punches")
    end 
  end 

  context 'when user has punches registered' do 

    let!(:punch) do 
      create(
        :punch,
        user: user,
      )
    end 

    it 'shows page with user punches', js: true do 
      visit "/new_admin/users/#{user.id}"
      click_button('Punches')
      expect(page).to have_content("PROJETO")
      expect(page).to have_content(punch.project.name)
      expect(page).to have_content("HORÁRIO INICIAL")
      expect(page).to have_content("ATÉ")
      expect(page).to have_content("DELTA")
      expect(page).to have_content("HORA EXTRA")
    end 

    it 'shows filter area for punches', js: true do 
      visit "/new_admin/users/#{user.id}"
      click_button('Punches')
      expect(page).to have_content("Filtro")
      expect(page).to have_content("INTERVALO")
      expect(page).to have_field("from")
      expect(page).to have_field("to")
      expect(page).to have_button("Filtrar")
      expect(page).to have_link("Limpar Filtro")
      expect(page).to have_link("Baixar XLS")
      expect(page).to have_link("Todos os Punches")
    end 
  end 

  context 'when punches are filtered' do 

    let!(:punch) do 
      create(
        :punch,
        created_at: 1.month.ago,
        user: user,
      )
    end 

    it 'returns the punch filtered by date', js: true do 
      visit "/new_admin/users/#{user.id}"
      click_button('Punches')
      fill_in "from", with: 1.month.ago
      fill_in "to", with: 1.day.ago
      find_button('Filtrar').click
      expect(page).to have_content(punch.project.name)
    end 
  end 
end 
