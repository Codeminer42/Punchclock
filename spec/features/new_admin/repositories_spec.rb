# frozen_string_literal: true

require 'rails_helper'

describe 'Repositories', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do
    sign_in(admin_user)
  end

  describe 'Actions' do
    before do
      visit '/new_admin/repositories'
    end

    context 'when on new' do
      before do
        find_link('Novo Repositório', href: '/new_admin/repositories/new').click
      end

      it 'shows form fields' do
        within "#form_repository" do
          expect(page).to have_content('Link') and
                          have_content('Descrição') and
                          have_content('Linguagem') and
                          have_content('Highlight')
        end

        expect(page).to have_button('Enviar')
      end

      it 'creates repository' do
        within "#form_repository" do
          fill_in 'repository_link', with: 'https://github.com/Codeminer42/Punchclock/'
          fill_in 'repository_description', with: 'Some description'
          fill_in 'repository_language', with: 'Ruby'
          check 'repository_highlight'
        end

        click_button 'Enviar'

        expect(page).to have_content('Repositório foi criado com sucesso.')
      end
    end
  end

end
