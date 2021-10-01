# frozen_string_literal: true

require 'rails_helper'

feature 'Punches list' do
  let!(:authed_user) { create_logged_in_user }
  let!(:punch) {
    create(:punch, user_id: authed_user.id, company_id: authed_user.company_id)
  }
  let!(:other_punch) {
    create(:punch, user_id: authed_user.id, company_id: authed_user.company_id)
  }

  before do
    visit '/punches'
    expect(page).to have_selector('a[href="/punches/new"]') &
                    have_selector('table') &
                    have_content('TOTAL:')
  end

  scenario 'follow show link', :skip do
    click_link "shw-#{punch.id}"

    expect(page).to have_content(I18n.localize(punch.from, format: '%d/%m/%Y')) &
                    have_content(I18n.localize(punch.from, format: '%H:%M')) &
                    have_content(I18n.localize(punch.to, format: '%H:%M')) &
                    have_content(punch.project.name) &
                    have_content(authed_user.name)
  end

  scenario 'follow edit link', :skip do
    click_link "edt-#{punch.id}"
    expect(page).to have_content I18n.t(
      :editing, scope: %i(helpers actions), model: Punch.model_name.human
    )
  end

  scenario 'follow destroy link', :skip do
    click_link "dlt-#{punch.id}"
    expect(page).to have_content('Punch foi deletado com sucesso.')
  end

  scenario 'filter punches' do
    fill_in 'punches_filter_form_since', with: I18n.localize(other_punch.from, format: '%d/%m/%Y')
    fill_in 'punches_filter_form_until', with: I18n.localize(other_punch.to + 1.day, format: '%d/%m/%Y')
    select other_punch.project.name, from: 'punches_filter_form_project_id'
    click_button 'Filtrar'

    expect(page).to have_css('tbody tr', count: 1)
  end
end
