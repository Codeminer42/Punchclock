# frozen_string_literal: true

require 'rails_helper'

describe 'Edit Punch', type: :feature do
  let!(:authed_user) { create_logged_in_user }
  let!(:active_project) { create(:project, :active) }
  let!(:inactive_project) { create(:project, :inactive) }
  let!(:punch) do
    create(:punch, user_id: authed_user.id)
  end

  it 'checking filled attributes' do
    visit "/punches/#{punch.id}/edit"

    expect(page).to have_field('punch[from_time]', with: time_format(punch.from)) &
                    have_field('punch[to_time]', with: time_format(punch.to)) &
                    have_field('punch[when_day]', with: I18n.l(punch.date))
  end

  it 'editing punch' do
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

  it 'editing punch with invalid data' do
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

  it 'select box without inactive project' do
    visit "/punches/#{punch.id}/edit"
    expect(page).to_not have_select 'punch[project_id]', with_options: [inactive_project.name]
  end

  def time_format(time)
    I18n.l(time, format: '%H:%M')
  end
end
