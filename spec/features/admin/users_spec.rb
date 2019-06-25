# frozen_string_literal: true

require 'rails_helper'

describe 'Users', type: :feature do
  let(:admin_user) { create(:super) }
  let(:user)       { create(:user, :admin) }

  before do
    admin_sign_in(admin_user)
    visit '/admin/users'
  end

  describe 'Scopes' do
    before do
      create(:user)
      create(:office, head: user)
      create(:allocation)
    end

    it 'have the "all" scope' do
      find_link('Todos', href: '/admin/users?scope=all').click

      within '#index_table_users' do
        expect(page).to have_css('tbody tr', count: 3)
      end
    end

    it 'have the "office heads" scope' do
      find_link('Office Heads', href: '/admin/users?scope=office_heads').click

      within '#index_table_users' do
        expect(page).to have_css('tbody tr', count: 1)
      end
    end

    it 'have the "admins" scope' do
      find_link('Admins', href: '/admin/users?scope=admins').click

      within '#index_table_users' do
        expect(page).to have_css('tbody tr', count: 1)
      end
    end

    it 'have the "not allocated" scope' do
      find_link('Não alocados', href: '/admin/users?scope=not_allocated').click

      within '#index_table_users' do
        expect(page).to have_css('tbody tr', count: 2)
      end
    end
  end

  describe 'Filters' do
    it 'by name' do
      within '#filters_sidebar_section' do
        expect(page).to have_css('label', text: 'Nome')
      end
    end

    it 'by role' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Nível', options: User.roles.keys.map(&:titleize) << 'Qualquer')
      end
    end

    it 'by specialty' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Especialidade', options: User.specialties.keys.map(&:humanize) << 'Qualquer')
      end
    end

    it 'by office' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Escritório', options: admin_user.company.offices.pluck(:city) << 'Qualquer')
      end
    end

    it 'by contract type' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Tipo de Contrato', options: User.contract_types.keys.map(&:humanize) << 'Qualquer')
      end
    end

    context 'after creating a skill' do
      let!(:skill) { create(:skill) }
      before { refresh }

      it 'finds it on by skills' do
        within '#q_by_skills_input' do
          expect(page).to have_text(skill.title)
        end
      end
    end
  end

  describe 'Actions' do
    let!(:skill)      { create(:skill) }
    let!(:office)     { create(:office, head: user) }
    let!(:office2)    { create(:office, head: user) }
    let!(:evaluation) { create :evaluation, :english, evaluated: user }
    let!(:allocation) { create(:allocation, :with_end_at, user: user) }

    describe 'New' do
      before do
        within '.action_items' do
          click_link 'Novo(a) Usuário'
        end
      end

      it 'must have the form working' do
        fill_in 'Nome', with: 'Foo Bar'
        fill_in 'E-mail', with: 'foo@bar.com'
        fill_in 'Github', with: 'userGithub'
        find('#user_office_id').find(:option, office.city).select_option
        find('#user_company_id').find(:option, admin_user.company.name).select_option
        find("#user_skill_ids_#{skill.id}").set(true)
        choose('Engineer')
        find('#user_specialty').find(:option, 'Backend').select_option
        find('#user_role').find(:option, 'Junior').select_option
        find('#user_contract_type').find(:option, 'Internship').select_option
        check('Ativo')
        fill_in 'Password', with: 'password'
        fill_in 'Observação', with: 'Observation'

        click_button 'Criar Usuário'

        expect(page).to have_css('.flash_notice', text: 'Usuário foi criado com sucesso.') &
                        have_text('Foo Bar') &
                        have_text('foo@bar.com') &
                        have_text('userGithub') &
                        have_text(office.city) &
                        have_text(skill.title) &
                        have_text('engineer') &
                        have_text('Backend') &
                        have_text('Junior') &
                        have_text('Internship') &
                        have_css('.row-active td', text: 'Sim') &
                        have_text('Observation')
      end
    end

    describe 'Show' do
      let!(:evaluations) { create_list :evaluation, 2, :performance, evaluated: user }

      before do
        visit '/admin/users'
        within 'table' do
          find_link("#{user.name}", href: "/admin/users/#{user.id}").click
        end
      end

      it 'have edit action' do
        expect(page).to have_link('Editar Usuário')
      end

      it 'have delete action' do
        expect(page).to have_link('Remover Usuário')
      end

      context 'on user tab' do
        it 'finds user information' do
          within '#usuario' do
            expect(page).to have_css('.row-name td', text: user.name) &
                            have_text(user.email) &
                            have_text(user.github) &
                            have_text(user.office.city) &
                            have_text(office.city) &
                            have_text(office2.city) &
                            have_css('.row-english_level td', text: evaluation.english_level.humanize) &
                            have_css('.row-overall_score td', text: user.overall_score) &
                            have_css('.row-performance_score td', text: user.performance_score) &
                            have_css('.row-occupation td', text: user.occupation) &
                            have_css('.row-specialty td', text: user.specialty.humanize) &
                            have_css('.row-role td', text: user.role.humanize) &
                            have_css('.row-contract_type td', text: user.contract_type.humanize) &
                            have_css('.row-observation td', text: user.observation)
          end
        end
      end

      context 'on User Allocations tab' do
        it 'finds user current allocation' do
          within '#alocacao' do
            expect(page).to have_css('.row-current_allocation td', text: allocation.project.name)
          end
        end

        it 'finds user current allocation even with end date undefined' do
          allocation.end_at = nil
          within '#alocacao' do
            expect(page).to have_css('.row-current_allocation td', text: allocation.project.name)
          end
        end

        it 'finds allocations table' do
          within '#alocacao' do
            expect(page).to have_css('.row-allocations tbody tr', count: 1)
          end
        end
      end

      context 'on Performance Evaluations tab' do
        it 'finds evaluations table' do
          within '#avaliacoes-de-desempenho' do
            expect(page).to have_css('.row-evaluation tbody tr', count: 2)
          end
        end
      end

      context 'on English Evaluations tab' do
        it 'finds correct information' do
          within '#avaliacoes-de-ingles' do
            expect(page).to have_css('.row-english_level td', text: evaluation.english_level.humanize) &
                            have_css('.row-english_score td', text: user.english_score) &
                            have_css('.row-evaluation tbody tr', count: 1)
          end
        end
      end

      context 'on Punches tab' do
        let!(:punch) { create :punch, user: user, from: DateTime.new(2019, 6, 6, 8, 8, 0, 0), to: DateTime.new(2019, 6, 6, 8, 12, 0, 0)}
        before { refresh }
        it 'finds all elements correctly' do
          within 'div#punches' do
            expect(page).to have_table('') &
                            have_css('.col.col-company', text: punch.company) &
                            have_css('.col.col-project', text: punch.project) &
                            have_css('.col.col-when', text: punch.when_day) &
                            have_css('.col.col-from', text: punch.from_time) &
                            have_css('.col.col-to', text: punch.to_time) &
                            have_css('.col.col-delta', text: punch.delta_as_hour) &
                            have_css('.col.col-extra_hour', text: punch.extra_hour) &
                            have_link(I18n.t('download_as_csv'), href: admin_punches_path(q: { user_id_eq: user.id, from_greater_than: Date.current - 60 }, format: :csv)) &
                            have_link(I18n.t('all_punches'), href: admin_punches_path(q: { user_id_eq: user.id, commit: :Filter }))
          end
        end
      end
    end

    describe 'Edit' do
      before do
        visit "/admin/users/#{user.id}"
        find_link("Editar Usuário", href: "/admin/users/#{user.id}/edit").click
      end

      it 'must have labels' do
        within 'form' do
          expect(page).to have_text('Nome') &
                          have_text('E-mail') &
                          have_text('Empresa') &
                          have_text('Escritório') &
                          have_text('Ocupação') &
                          have_text('Especialidade') &
                          have_text('Tipo de Contrato') &
                          have_text('Nível') &
                          have_text('Habilidades') &
                          have_text('Observação')
        end
      end

      it 'updates user information' do
        find('#user_email').fill_in with: 'novo_email@codeminer42.com'

        click_button 'Atualizar Usuário'

        expect(page).to have_css('.flash_notice', text: 'Usuário foi atualizado com sucesso.') &
                        have_text('novo_email@codeminer42.com')
      end
    end
  end
end
