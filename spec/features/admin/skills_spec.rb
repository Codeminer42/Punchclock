# frozen_string_literal: true

require 'rails_helper'

describe 'Admin Skill', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do
    sign_in(admin_user)
    visit '/admin/skills'
  end

  describe 'Filters' do
    it 'by title' do
      within '#filters_sidebar_section' do
        expect(page).to have_css('label', text: 'Título')
      end
    end
  end

  describe 'Actions' do
    let!(:skill) { create(:skill) }

    it 'must have the form working' do
      click_link 'Novo(a) Habilidade'
      fill_in 'Título', with: 'Ruby'
      click_button 'Criar Habilidade'

      expect(page).to have_text('Habilidade foi criado com sucesso.') &
                      have_css('td', text: 'Ruby')
    end

    it 'do not create the same skill' do
      click_link 'Novo(a) Habilidade'
      fill_in 'Título', with: 'Ruby'
      click_button 'Criar Habilidade'

      visit '/admin/skills'

      click_link 'Novo(a) Habilidade'
      fill_in 'Título', with: 'Ruby'
      click_button 'Criar Habilidade'

      expect(page).to have_text('Habilidade não pôde ser criado.')
    end

    it 'have edit action' do
      visit '/admin/skills'
      find_link("#{skill.title}", href: "/admin/skills/#{skill.id}").click

      expect(page).to have_link('Editar Habilidade')
    end

    it 'have delete action' do
      visit '/admin/skills'
      find_link("#{skill.title}", href: "/admin/skills/#{skill.id}").click

      expect(page).to have_link('Remover Habilidade')
    end
  end
end
