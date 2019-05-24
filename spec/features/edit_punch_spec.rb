# frozen_string_literal: true

require 'rails_helper'

feature 'Edit Punch' do
  let!(:authed_user) { create_logged_in_user }
  let!(:active_project) { create(:project, :active, company_id: authed_user.company_id) }
  let!(:inactive_project) { create(:project, :inactive, company_id: authed_user.company_id) }
  let!(:punch) do
    create(:punch, user_id: authed_user.id, company_id: authed_user.company_id)
  end

  scenario 'checking filled attributes' do
    visit "/punches/#{punch.id}/edit"

    expect(page).to have_field('punch[from_time]', with: time_format(punch.from)) &
                    have_field('punch[to_time]', with: time_format(punch.to)) &
                    have_field('punch[when_day]', with: I18n.l(punch.date))
  end

  scenario 'editing punch' do
    visit "/punches/#{punch.id}/edit"

    expect(page).to have_content I18n.t(
      :editing, scope: %i[helpers actions], model: Punch.model_name.human
    )

    within "#edit_punch_#{punch.id}" do
      fill_in 'punch[from_time]', with: '08:00'
      fill_in 'punch[to_time]', with: '12:00'
      fill_in 'punch[when_day]', with: '2001-01-05'
      select active_project.name, from: 'punch[project_id]'
      click_button 'Atualizar Punch'
    end

    expect(page).to have_content('Punch foi atualizado com sucesso.')
  end

  scenario 'editing punch with invalid data' do
    visit "/punches/#{punch.id}/edit"
    expect(page).to have_content I18n.t(
      :editing, scope: %i[helpers actions], model: Punch.model_name.human
    )

    within "#edit_punch_#{punch.id}" do
      fill_in 'punch[from_time]', with: '12:00'
      fill_in 'punch[to_time]', with: '8:00'
      fill_in 'punch[when_day]', with: '2001-01-05'
      select active_project.name, from: 'punch[project_id]'
      click_button 'Atualizar Punch'
    end
    expect(page).to have_content('Punch não pôde ser atualizado.')
  end

  scenario 'select box without inactive project' do
    visit "/punches/#{punch.id}/edit"
    expect(page).to_not have_select 'punch[project_id]', with_options: [inactive_project.name]
  end

  def time_format(time)
    I18n.l(time, format: '%H:%M')
  end
end
