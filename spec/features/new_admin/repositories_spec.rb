# frozen_string_literal: true

require 'rails_helper'

describe 'Repositories', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do
    sign_in(admin_user)
  end

  describe 'Actions' do
    let!(:repository) do
      create(:repository,
              link: 'https://github.com/Codeminer42/Punchclock',
              language: 'Ruby',
              highlight: true,
              description: 'Some description')
    end

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

      context 'when the link field is valid' do
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

      context 'when the link field is invalid' do
        it 'does not create the repository' do
          within "#form_repository" do
            fill_in 'repository_link', with: ''
          end

          click_button 'Enviar'

          expect(page).to have_content('Link não pode ficar em branco')
        end
      end
    end

    context 'when on edit' do
      before do
        find_link("", href: "/new_admin/repositories/#{repository.id}/edit").click
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

      context 'when the link field is valid' do
        it 'updates the repository' do
          within "#form_repository" do
            fill_in 'repository_link', with: 'https://github.com/Codeminer42/Punchclock2/'
          end

          click_button 'Enviar'

          expect(page).to have_content('Repositório foi atualizado com sucesso.') and
                          have_content('https://github.com/Codeminer42/Punchclock2/')
        end
      end

      context 'when the link field is invalid' do
        it 'does not update the repository' do
          within "#form_repository" do
            fill_in 'repository_link', with: ''
          end

          click_button 'Enviar'

          expect(page).to have_content('Link não pode ficar em branco')
        end
      end
    end

    context 'when on destroy' do
      context 'when user deletes repository from index page' do

        it 'deletes the repository', :aggregate_failures do
            expect do
              find_all("a[href=\"/new_admin/repositories/#{repository.id}\"]")[1].click
            end.to change(Repository, :count).from(1).to(0)

          expect(page).to have_content("Repositório foi deletado com sucesso.")
        end
      end

      context 'when user deletes repository from show page' do
        before { visit "/new_admin/repositories/#{repository.id}" }

        it 'deletes the repository', :aggregate_failures do
          within '#repository_actions' do
            expect do
              find_link("Remover Repositório", href: "/new_admin/repositories/#{repository.id}").click
            end.to change(Repository, :count).from(1).to(0)
          end

          expect(page).to have_content("Repositório foi deletado com sucesso.")
        end
      end
    end
  end
end
