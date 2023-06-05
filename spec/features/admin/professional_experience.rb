# frozen_string_literal: true

require 'rails_helper'

describe 'ProfessionalExperience', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let!(:user) { create(:user, :admin) }
  let!(:another_user) { create(:user) }
  let!(:professional_experiences) { create_list(:professional_experience, 15) }
  let!(:professional_experience) { create(:professional_experience, user: user) }

  before do
    sign_in(admin_user)
    visit '/admin/professional_experiences'
  end

  describe 'Index' do
    it 'must find fields "User", "Company", "Position", "Start Date", and "End Date" on table' do
      within 'table' do
        expect(page).to have_text('Usuário') &
                        have_text('Empresa') &
                        have_text('Cargo') &
                        have_text('Data de início') &
                        have_text('Data de término')
      end
    end
  end

  describe 'Filters' do
    it 'by user' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Usuário', options: User.all.pluck(:name) << 'Qualquer')
        select user.name, from: 'Usuário'
        click_button 'Filtrar'
      end

      within 'table' do
        expect(page).to have_content(user.name)
      end

      within '#filters_sidebar_section' do
        click_link 'Limpar Filtros'
        select another_user.name, from: 'Usuário'
        click_button 'Filtrar'
      end

      expect(page).to have_content('Nenhum(a) Experiências Profissionais encontrado(a)')
    end

    it 'by company' do
      within '#filters_sidebar_section' do
        fill_in 'q_company', with: professional_experience.company
        click_button 'Filtrar'
      end

      within 'table' do
        expect(page).to have_content(professional_experience.company)
      end

      within '#filters_sidebar_section' do
        click_link 'Limpar Filtros'
        fill_in 'q_company', with: 'Test Company'
        click_button 'Filtrar'
      end

      expect(page).to have_content('Nenhum(a) Experiências Profissionais encontrado(a)')
    end
    it 'by position' do
      within '#filters_sidebar_section' do
        fill_in 'q_position', with: professional_experience.position
        click_button 'Filtrar'
      end

      within 'table' do
        expect(page).to have_content(professional_experience.position)
      end

      within '#filters_sidebar_section' do
        click_link 'Limpar Filtros'
        fill_in 'q_position', with: 'Test position'
        click_button 'Filtrar'
      end

      expect(page).to have_content('Nenhum(a) Experiências Profissionais encontrado(a)')
    end
  end

  describe 'Actions' do
    describe 'New' do
      before do
        visit '/admin/professional_experiences'
        click_link 'Novo(a) Experiência Profissional'
      end

      it 'must have the form working' do
        find('#professional_experience_user_id').find(:option, user.name).select_option
        find('#professional_experience_company').fill_in with: 'ABC Corp'
        find('#professional_experience_position').fill_in with: 'Software Engineer'
        find('#professional_experience_description').fill_in with: 'Worked on web application development.'
        find('#professional_experience_responsibilities').fill_in with: 'Implemented new features and bug fixes.'
        find('#professional_experience_start_date').fill_in with: 8.years.ago
        find('#professional_experience_end_date').fill_in with: 4.years.ago

        click_button 'Criar Experiência Profissional'

        expect(page).to have_text('Experiência Profissional foi criado com sucesso.') &
                        have_text(user.name) &
                        have_text('ABC Corp') &
                        have_text('Software Engineer')
      end
    end

    describe 'Show' do
      before do
        visit '/admin/professional_experiences'
        within 'table' do
          find_link('Visualizar', href: "/admin/professional_experiences/#{professional_experience.id}").click
        end
      end

      it 'have edit action' do
        expect(page).to have_link('Editar Experiência Profissional')
      end

      it 'have delete action' do
        expect(page).to have_link('Remover Experiência Profissional')
      end

      it 'must have labels' do
        within '.attributes_table.professional_experience' do
          expect(page).to have_text('Empresa') &
                          have_text('Cargo') &
                          have_text('Usuário') &
                          have_text('Data de início') &
                          have_text('Data de término')
        end
      end

      it 'have user table with correct information' do
        expect(page).to   have_text(professional_experience.user.name) &
                          have_text(professional_experience.company) &
                          have_text(professional_experience.position)
      end
    end

    describe 'Edit' do
      before do
        visit "/admin/professional_experiences/#{professional_experience.id}"
        click_link('Editar Experiência Profissional')
      end

      it 'must have labels' do
        within 'form' do
          expect(page).to have_text('Usuário') &
                          have_text('Empresa') &
                          have_text('Cargo') &
                          have_text('Data de início') &
                          have_text('Data de término')
        end
      end

      it 'updates professional experience information' do
        find('#professional_experience_company').fill_in with: 'XYZ Inc'

        click_button 'Atualizar Experiência Profissional'

        expect(page).to have_css('.flash_notice', text: 'Experiência Profissional foi atualizado com sucesso.') &
                        have_text('XYZ Inc') &
                        have_text(professional_experience.position)
      end
    end

    describe 'Destroy' do
      let!(:another_professional_experience) { create(:professional_experience) }

      it 'cancel delete professional experience', js: true do
        visit "/admin/professional_experiences/#{another_professional_experience.id}"

        page.dismiss_confirm do
          find_link("Remover Experiência Profissional", href: "/admin/professional_experiences/#{another_professional_experience.id}").click
        end

        expect(current_path).to eql("/admin/professional_experiences/#{another_professional_experience.id}")
      end

      it 'confirm delete professional experience', js: true do
        visit "/admin/professional_experiences/#{another_professional_experience.id}"

        page.accept_confirm do
          find_link("Remover Experiência Profissional", href: "/admin/professional_experiences/#{another_professional_experience.id}").click
        end

        expect(page).to have_text('Experiência Profissional foi deletado com sucesso.') &
                        have_no_link(professional_experience.company, href: "/admin/professional_experiences/#{professional_experience.id}")
      end
    end
  end
end

