# frozen_string_literal: true

require 'rails_helper'

describe 'Talks', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let!(:user)      { create(:user, :admin) }
  let!(:another_user)      { create(:user) }
  let!(:talks) { create_list(:talk, 15) }
  let!(:talk) { create(:talk, user: user).decorate }

  before do
    sign_in(admin_user)
    visit '/admin/talks'
  end

  describe 'Index' do
    it 'must find fields "User", "Event Name", "Talk Title" and "Date" on table' do
      within 'table' do
        expect(page).to have_text('Nome do evento') &
                        have_text('Título da palestra') &
                        have_text('Data') &
                        have_text('Usuário') &
                        have_text('Criado em') &
                        have_text('Atualizado em')
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

      expect(page).to have_content('Nenhum(a) Palestras encontrado(a)')
    end

    it 'by event name' do
      within '#filters_sidebar_section' do
        fill_in 'q_event_name', with: talk.event_name
        click_button 'Filtrar'
      end

      within 'table' do
        expect(page).to have_content(talk.event_name)
      end

      within '#filters_sidebar_section' do
        click_link 'Limpar Filtros'
        fill_in 'q_event_name', with: "teste"
        click_button 'Filtrar'
      end

      expect(page).to have_content('Nenhum(a) Palestras encontrado(a)')
    end

    it 'by talk title' do
      within '#filters_sidebar_section' do
        fill_in 'q_talk_title', with: talk.talk_title
        click_button 'Filtrar'
      end

      within 'table' do
        expect(page).to have_content(talk.talk_title)
      end

      within '#filters_sidebar_section' do
        click_link 'Limpar Filtros'
        fill_in 'q_talk_title', with: "teste"
        click_button 'Filtrar'
      end

      expect(page).to have_content('Nenhum(a) Palestras encontrado(a)')
    end

    let!(:older_talk) { create(:talk, user: user, date: 10.years.ago).decorate }

    it 'by talk date' do
      within '#filters_sidebar_section' do
        fill_in 'q_date_gteq', with: talk.date
        click_button 'Filtrar'
      end

      within 'table' do
        expect(page).to have_content(talk.talk_title)
        expect(page).to_not have_content(older_talk.talk_title)
      end

      within '#filters_sidebar_section' do
        click_link 'Limpar Filtros'
        fill_in 'q_date_gteq', with: Date.today
        click_button 'Filtrar'
      end

      expect(page).to have_content('Nenhum(a) Palestras encontrado(a)')
    end
  end

  describe 'Actions' do
    describe 'New' do
      before do
        visit '/admin/talks'
        click_link 'Novo(a) Palestra'
      end

      it 'must have the form working' do
        find('#talk_user_id').find(:option, user.name).select_option
        find('#talk_event_name').fill_in with: 'Ruby Conf'
        find('#talk_talk_title').fill_in with: 'My Presentation'
        find('#talk_date').fill_in with: 2.months.ago

        click_button 'Criar Palestra'

        expect(page).to have_text('Palestra foi criado com sucesso.') &
                        have_text(user.name) &
                        have_text('Ruby Conf') &
                        have_text('My Presentation')
      end
    end

    describe 'Show' do
      before do
        visit '/admin/talks'
        within 'table' do
          find_link('Visualizar', href: "/admin/talks/#{talk.id}").click
        end
      end

      it 'have edit action' do
        expect(page).to have_link('Editar Palestra')
      end

      it 'have delete action' do
        expect(page).to have_link('Remover Palestra')
      end

      it 'must have labels' do
        within '.attributes_table.talk' do
          expect(page).to have_text('Nome do evento') &
                          have_text('Título da palestra') &
                          have_text('Data') &
                          have_text('Usuário') &
                          have_text('Criado em') &
                          have_text('Atualizado em')
        end
      end

      it 'have user table with correct information' do
        expect(page).to   have_text(talk.event_name) &
                          have_text(talk.talk_title) &
                          have_text(talk.date)
      end
    end

    describe 'Edit' do
      before do
        visit "/admin/talks/#{talk.id}"
        click_link('Editar Palestra')
      end

      it 'must have labels' do
        within 'form' do
          expect(page).to have_text('Nome do evento') &
                          have_text('Título da palestra') &
                          have_text('Data') &
                          have_text('Usuário')
        end
      end

      it 'updates talk information' do
        find('#talk_event_name').fill_in with: 'Rails Conf'

        click_button 'Atualizar Palestra'

        expect(page).to have_css('.flash_notice', text: 'Palestra foi atualizado com sucesso.') &
                        have_text('Rails Conf') &
                        have_text(talk.talk_title)
      end
    end

    describe 'Destroy' do
      let!(:another_talk) { create(:talk, user: another_user) }

      it 'cancel delete talk', js: true do
        visit "/admin/talks/#{another_talk.id}"

        page.dismiss_confirm do
          find_link("Remover Palestra", href: "/admin/talks/#{another_talk.id}").click
        end

        expect(current_path).to eql("/admin/talks/#{another_talk.id}")
      end

      it 'confirm delete talk', js: true do
        visit "/admin/talks/#{another_talk.id}"

        page.accept_confirm do
          find_link("Remover Palestra", href: "/admin/talks/#{another_talk.id}").click
        end

        expect(page).to have_text('Palestra foi deletado com sucesso.') &
                        have_no_link(talk.event_name, href: "/admin/talks/#{talk.id}")
      end
    end
  end
end
