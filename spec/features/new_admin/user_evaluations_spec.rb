describe 'User Evaluations', type: :feature do 

  let(:user) { create(:user, name: "Jorge").decorate }
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do 
    sign_in(admin_user)
    visit "/new_admin/users/#{user.id}"
  end 

  context 'when user has no evaluations' do 
    it 'shows evaluations table without results', js: true do 
      click_button('Avaliações de Desempenho')
      expect(page).to_not have_css("td")
    end 
  end 

  context 'when user has evaluations' do 

    let!(:evaluation) do
      create(
        :evaluation, 
        evaluator: admin_user, 
        evaluated: user,
        score: 10, 
        evaluation_date: 1.day.ago
      )
    end

    it 'shows table with user evaluation', js: true do 
      visit "/new_admin/users/#{user.id}"
      click_button('Avaliações de Desempenho')
      expect(page).to have_css("td") &&
        have_content(evaluation.evaluator) &&
        have_content(evaluation.evaluated) &&
        have_content(evaluation.questionnaire) &&
        have_content(evaluation.score) &&
        have_link('Acessar Avaliação')
    end 
  end 
end 
