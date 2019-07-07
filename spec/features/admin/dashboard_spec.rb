require 'rails_helper'

describe 'Dashboard', type: :feature do
  let(:admin_user) { create(:user, :super_admin, occupation: :administrative) }
  let!(:user)      { create(:user, company: admin_user.company) }
  let!(:user2)     { create(:user, company: admin_user.company) }
  let!(:office)    { create(:office, company: admin_user.company, head: user) }
  let!(:client)    { create(:client, company: admin_user.company) }
  let!(:project)    { create(:project, company: admin_user.company, client: client) }

  before do
    sign_in(admin_user)
    visit '/admin/dashboard'
  end

  describe 'Search filter' do
    it 'have user options' do
      within '#user_id_input' do
        user1_option = "#{user.name.titleize} - #{user.email} - #{user.level.humanize} -"\
                       " #{user.office} - Não Alocado"
        user2_option = "#{user2.name.titleize} - #{user2.email} - #{user2.level.humanize} -"\
                       " #{user2.office} - Não Alocado"

        expect(page).to have_text(user1_option) &
                        have_text(user1_option)
      end
    end

    it 'have office options' do
      within '#office_id_input' do
        expect(page).to have_text(
                                  "#{office.city.titleize} - " \
                                  "#{office.head} - " \
                                  "Usuários não foram todos avaliados")
      end
    end

    it 'have project options' do
      within '#project_id_input' do
        expect(page).to have_text("#{project.name} - #{project.client.name}")
      end
    end
  end
end
