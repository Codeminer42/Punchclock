describe 'User English Evaluations', type: :feature do 
  let(:user) { create(:user, name: "Jorge").decorate }
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do 
    sign_in(admin_user)
    visit "/new_admin/users/#{user.id}"
  end 

  context 'when user has no english evaluations' do 
    it 'shows english evaluations table without results', js: true do 
      click_button('Avaliações de Inglês')
      expect(page).to_not have_css("td")
      expect(page).to have_content("Não avaliado")
    end 
  end 

  context 'when user has english evaluations' do 

    let!(:evaluation) do 
      create(
        :evaluation, 
        :english,
        evaluator: admin_user, 
        evaluated: user,
      )
    end 

    it 'shows user english level', js: true do
      visit "/new_admin/users/#{user.id}"
      click_button('Avaliações de Inglês')
      expect(page).to have_content(user.english_level)
    end

    it 'shows user english score', js: true do 
      visit "/new_admin/users/#{user.id}"
      click_button('Avaliações de Inglês')
      expect(page).to have_content(evaluation.score)
    end 

    it 'shows table with user english evaluations', js: true do 
      visit "/new_admin/users/#{user.id}"
      click_button('Avaliações de Inglês')
      expect(page).to have_css("td")
      expect(page).to have_content(evaluation.evaluator) 
      expect(page).to have_content(evaluation.score)
      expect(page).to have_content(evaluation.questionnaire.title)  
      expect(page).to have_content('Acessar Avaliação') 
    end
  end
end
