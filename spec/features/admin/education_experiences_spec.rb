# frozen_string_literal: true

require 'rails_helper'

describe 'EducationExperience', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let!(:user)      { create(:user, :admin) }
  let!(:another_user)      { create(:user) }
  let!(:education_experiences) { create_list(:education_experience, 15) }
  let!(:education_experience) { create(:education_experience, user: user) }

  before do
    sign_in(admin_user)
    visit '/admin/education_experiences'
  end

  describe 'Index' do
    it 'must find fields "User", "Institution", "Course", "Start Date" and "End Date" on table' do
      within 'table' do
        expect(page).to have_text('Usuário') &
                        have_text('Instituição') &
                        have_text('Curso') &
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

      expect(page).to have_content('Nenhum(a) Experiências Educacionais encontrado(a)')
    end

    it 'by institution' do
      within '#filters_sidebar_section' do
        fill_in 'q_institution', with: user.education_experiences.first.institution
        click_button 'Filtrar'
      end

      within 'table' do
        expect(page).to have_content(user.education_experiences.first.institution)
      end

      within '#filters_sidebar_section' do
        click_link 'Limpar Filtros'
        fill_in 'q_institution', with: "teste"
        click_button 'Filtrar'
      end

      expect(page).to have_content('Nenhum(a) Experiências Educacionais encontrado(a)')
    end

    it 'by course' do
      within '#filters_sidebar_section' do
        fill_in 'q_course', with: user.education_experiences.first.course
        click_button 'Filtrar'
      end

      within 'table' do
        expect(page).to have_content(user.education_experiences.first.course)
      end

      within '#filters_sidebar_section' do
        click_link 'Limpar Filtros'
        fill_in 'q_course', with: "teste"
        click_button 'Filtrar'
      end

      expect(page).to have_content('Nenhum(a) Experiências Educacionais encontrado(a)')
    end
  end

  describe 'Actions' do
    describe 'New' do
      before do
        visit '/admin/education_experiences'
        click_link 'Novo(a) Experiência Educacional'
      end

      it 'must have the form working' do
        find('#education_experience_user_id').find(:option, user.name).select_option
        find('#education_experience_institution').fill_in with: 'Ivy Uni'
        find('#education_experience_course').fill_in with: 'Computer Science'
        find('#education_experience_start_date').fill_in with: 8.years.ago
        find('#education_experience_end_date').fill_in with: 4.years.ago

        click_button 'Criar Experiência Educacional'

        expect(page).to have_text('Experiência Educacional foi criado com sucesso.') &
                        have_text(user.name) &
                        have_text('Ivy Uni') &
                        have_text('Computer Science')
      end
    end

    describe 'Show' do
      before do
        visit '/admin/education_experiences'
        within 'table' do
          find_link('Visualizar', href: "/admin/education_experiences/#{education_experience.id}").click
        end
      end

      it 'have edit action' do
        expect(page).to have_link('Editar Experiência Educacional')
      end

      it 'have delete action' do
        expect(page).to have_link('Remover Experiência Educacional')
      end

      it 'must have labels' do
        within '.attributes_table.education_experience' do
          expect(page).to have_text('Instituição') &
                          have_text('Curso') &
                          have_text('Usuário') &
                          have_text('Data de início') &
                          have_text('Data de término')
        end
      end

      it 'have user table with correct information' do
        expect(page).to   have_text(education_experience.user.name) &
                          have_text(education_experience.institution) &
                          have_text(education_experience.course)
      end
    end

    describe 'Edit' do
      before do
        visit "/admin/education_experiences/#{education_experience.id}"
        click_link('Editar Experiência Educacional')
      end

      it 'must have labels' do
        within 'form' do
          expect(page).to have_text('Usuário') &
                          have_text('Instituição') &
                          have_text('Curso') &
                          have_text('Data de início') &
                          have_text('Data de término')
        end
      end

      it 'updates education experience information' do
        find('#education_experience_institution').fill_in with: 'Uni'

        click_button 'Atualizar Experiência Educacional'

        expect(page).to have_css('.flash_notice', text: 'Experiência Educacional foi atualizado com sucesso.') &
                        have_text('Uni') &
                        have_text(education_experience.course)
      end
    end

    describe 'Destroy' do
      let!(:another_education_experience) { create(:education_experience) }

      it 'cancel delete education experience', js: true do
        visit "/admin/education_experiences/#{another_education_experience.id}"

        page.dismiss_confirm do
          find_link("Remover Experiência Educacional", href: "/admin/education_experiences/#{another_education_experience.id}").click
        end

        expect(current_path).to eql("/admin/education_experiences/#{another_education_experience.id}")
      end

      it 'confirm delete education experience', js: true do
        visit "/admin/education_experiences/#{another_education_experience.id}"

        page.accept_confirm do
          find_link("Remover Experiência Educacional", href: "/admin/education_experiences/#{another_education_experience.id}").click
        end

        expect(page).to have_text('Experiência Educacional foi deletado com sucesso.') &
                        have_no_link(education_experience.course, href: "/admin/education_experiences/#{education_experience.id}")
      end
    end
  end
end
