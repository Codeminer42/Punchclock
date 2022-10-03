# frozen_string_literal: true

require 'rails_helper'

describe 'Users', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let(:user)       { create(:user, :with_started_at) }

  before do
    sign_in(admin_user)
    visit '/admin/users'
  end

  describe 'Scopes' do
    let(:allocated_user) { create(:user) }

    before do
      create(:user)
      create(:office, head: user)
      create(:allocation, user: allocated_user, ongoing: true)
    end

    it 'have the "all" scope' do
      find_link('Todos', href: '/admin/users?scope=all').click

      within '#index_table_users' do
        expect(page).to have_css('tbody tr', count: 4)
      end
    end

    it 'have the "office heads" scope' do
      find_link('Office Heads', href: '/admin/users?scope=office_heads').click

      within '#index_table_users' do
        expect(page).to have_css('tbody tr', count: 1) &&
        have_css('.col-name', text: user.name) &&
        have_css('.col-office', text: user.office.city) &&
        have_css('.col-level', text: user.level.humanize) &&
        have_css('.col-specialty', text: user.specialty.humanize) &&
        have_css('.col-allow_overtime', text: I18n.t(user.allow_overtime)) &&
        have_css('.col-active', text: I18n.t(user.active)) &&
        have_css('.col-2fa', text: I18n.t(user.otp_required_for_login))
      end
    end

    it 'have the "admins" scope' do
      find_link('Admin', href: '/admin/users?scope=admin').click

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

    it 'by level' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Nível', options: User.level.values.map { |key| key.text.titleize } << 'Qualquer')
      end
    end

    it 'by specialty' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Especialidade', options: User.specialty.values.map { |key| key.text.humanize } << 'Qualquer')
      end
    end

    it 'by office' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Escritório', options: Office.pluck(:city) << 'Qualquer')
      end
    end

    it 'by contract type' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Tipo de Contrato', options: User.contract_type.values.map { |key| key.text.humanize } << 'Qualquer')
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
    let!(:city)      { create(:city) }
    let!(:skill)      { create(:skill) }
    let!(:office)     { create(:office, head: user) }
    let!(:office2)    { create(:office, head: user) }
    let!(:evaluation) { create(:evaluation, :english, evaluated: user) }
    let!(:allocation) { create(:allocation, user: user, ongoing: true) }
    let(:started_at) { 1.week.ago }

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
        find('#user_started_at').fill_in with: started_at.strftime('%Y-%m-%d')
        find('#user_office_id').find(:option, office.city).select_option
        find('#user_city_id').find(:option, city.name).select_option
        find("#user_skill_ids_#{skill.id}").set(true)
        choose('Engenheiro')
        find('#user_specialty').find(:option, 'Backend').select_option
        find('#user_level').find(:option, 'Junior').select_option
        find('#user_contract_type').find(:option, 'Estagiário').select_option
        find('#user_contract_company_country').find(:option, 'Brasil').select_option
        check('Ativo')
        fill_in 'Observação', with: 'Observation'

        click_button 'Criar Usuário'
        expect(page).to have_css('.flash_notice', text: 'Usuário foi criado com sucesso.') &
                        have_text('Foo Bar') &
                        have_text('foo@bar.com') &
                        have_text('userGithub') &
                        have_text(I18n.l(started_at, format: '%d de %B de %Y')) &
                        have_text(office.city) &
                        have_text(skill.title) &
                        have_text('Engenheiro') &
                        have_text('Backend') &
                        have_text('Junior') &
                        have_text('Estagiário') &
                        have_text('Admin') &
                        have_css('.row-active td', text: 'Sim') &
                        have_text('Observation')
      end

      it "must deactivate User specialty and level when 'administrative' occupation is selected", js: true do
        find('#user_specialty').find(:option, 'Backend').select_option
        find('#user_level').find(:option, 'Junior').select_option

        choose('Administrativo')

        expect(page).to have_select('user_specialty', disabled: true, selected: '') &
                        have_select('user_level', disabled: true, selected: '')
      end
    end

    describe 'Show' do
      let!(:evaluations) { create_list :evaluation, 2, :performance, evaluated: user }
      let!(:user_2fa) { create(:user, :active_user) }

      before do
        user_2fa.otp_secret = user_2fa.class.generate_otp_secret
        user_2fa.otp_required_for_login = true
        user_2fa.save

        visit '/admin/users'
        within 'table' do
          find_link(user.name.to_s, href: "/admin/users/#{user.id}").click
        end
      end

      it 'have edit action' do
        expect(page).to have_link('Editar Usuário')
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
                            have_css('.row-started_at td', text: I18n.l(user.started_at, format: :long)) &
                            have_css('.row-english_level td', text: evaluation.english_level.humanize) &
                            have_css('.row-2fa td', text: I18n.t(user.otp_required_for_login)) &
                            have_css('.row-active td', text: I18n.t(user.active)) &
                            have_css('.row-overall_score td', text: user.overall_score) &
                            have_css('.row-performance_score td', text: user.performance_score) &
                            have_css('.row-occupation td', text: user.occupation_text) &
                            have_css('.row-specialty td', text: user.specialty.humanize) &
                            have_css('.row-level td', text: user.level.humanize) &
                            have_css('.row-contract_type td', text: user.contract_type_text) &
                            have_css('.row-roles td', text: UserDecorator.new(user).roles_text) &
                            have_css('.row-observation td', text: user.observation)
          end
        end
      end

      context 'on User Allocations tab' do
        it 'finds user current allocation' do
          within '#alocacoes' do
            expect(page).to have_css('.row-current_allocation td', text: allocation.project.name)
          end
        end

        it 'finds user current allocation even with end date undefined' do
          within '#alocacoes' do
            expect(page).to have_css('.row-current_allocation td', text: allocation.project.name)
          end
        end

        it 'finds allocations table' do
          within '#alocacoes' do
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
        let!(:monday_1_month_ago) { (DateTime.new(2021, 6, 1) - 4.week).monday }
        let!(:punch) { create :punch, user: user, from: monday_1_month_ago.change(hour: 8, min: 8, sec: 0), to: monday_1_month_ago.change(hour: 12, min: 0, sec: 0) }

        it 'finds all elements correctly' do
          within 'div#punches' do
            travel_to Time.new(2021, 6, 1) do
              refresh
              expect(page).to have_table('') &
                              have_text('Projeto') &
                              have_css('.col.col-when', text: punch.when_day) &
                              have_css('.col.col-from', text: punch.from_time) &
                              have_css('.col.col-to', text: punch.to_time) &
                              have_text('Delta') &
                              have_css('.col.col-extra_hour', text: punch.extra_hour) &
                              have_link(I18n.t('download_as_xls'), href: admin_punches_path(q: { user_id_eq: user.id, from_greater_than: 60.days.ago, from_lteq: Time.zone.now }, format: :xls)) &
                              have_link(I18n.t('all_punches'), href: admin_punches_path(q: { user_id_eq: user.id, commit: :Filter }))
            end
          end
        end
      end

      context 'on Punches tab and filtering results' do
        let!(:punch1) { create :punch, user: user, from: DateTime.new(2019, 6, 6, 8, 8, 0, 0), to: DateTime.new(2019, 6, 6, 8, 12, 0, 0) }
        let!(:punch2) { create :punch, user: user, from: DateTime.new(2019, 6, 4, 8, 8, 0, 0), to: DateTime.new(2019, 6, 4, 8, 12, 0, 0) }

        before { refresh }
        it 'finds all elements correctly' do
          within '#filtro_sidebar_section' do
            fill_in 'punch_from_gteq', with: DateTime.new(2019, 6, 5, 8, 8, 0, 0)
            fill_in 'punch_from_lteq', with: DateTime.new(2019, 6, 7, 8, 8, 0, 0)
            click_button 'Filtrar'
          end

          within 'div#punches' do
            expect(page).to have_selector("#punch_#{punch1.id}", count: 1)
            expect(page).not_to have_selector("#punch_#{punch2.id}")
          end
        end
      end
    end

    describe 'Edit' do
      before do
        visit "/admin/users/#{user.id}"
        find_link('Editar Usuário', href: "/admin/users/#{user.id}/edit").click
      end

      it 'must have labels' do
        within 'form' do
          expect(page).to have_text('Nome') &
                          have_text('E-mail') &
                          have_text('Escritório') &
                          have_text('Ocupação') &
                          have_text('Especialidade') &
                          have_text('Tipo de Contrato') &
                          have_text('Funções') &
                          have_text('Nível') &
                          have_text('Iniciou em') &
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

    describe 'Edit yourself', js: true do
      before do
        visit "/admin/users/#{admin_user.id}"
        find_link('Editar Usuário', href: "/admin/users/#{admin_user.id}/edit").click
      end

      it 'updates yourself role information' do
        first('li', text: 'Admin')
        find_by_id('user_roles_input').find('.selection').click
        first('li', text: 'Evaluator').click
        click_button 'Atualizar Usuário'

        expect(current_path).to eq "/admin/users/#{admin_user.id}"

        expect(page).to have_css('.flash_notice', text: 'Usuário foi atualizado com sucesso.')
      end
    end
  end
end
