require 'spec_helper'

feature 'Evaluation' do
  let!(:reviewer) { create_logged_in_user }
  let!(:user) { create(:user, reviewer: reviewer) }
  let(:evaluation) { create(:evaluation, reviewer: reviewer, user: user) }

  scenario 'create evaluation' do
    visit new_evaluation_path

    expect(page).to have_content('Criando Avaliação')

    within '#new_evaluation' do
      select user.name, from: 'evaluation[user_id]'
      fill_in 'evaluation[review]', with: 'Foo'
      click_button 'Salvar Revisão'
    end

    expect(page).to have_content('Avaliação foi criada com sucesso.')
  end

  scenario 'edit evaluation' do
    visit edit_evaluation_path(evaluation)

    expect(page).to have_content("Editando Avaliação")

    within "#edit_evaluation_#{evaluation.id}" do
      fill_in 'evaluation[review]', with: 'Bar'
      click_button 'Salvar Revisão'
    end

    expect(page).to have_content('Avaliação foi atualizada com sucesso.')
  end
end
