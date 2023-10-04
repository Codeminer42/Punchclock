require 'rails_helper'

describe 'Dashboard', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let!(:user)      { create(:user) }
  let!(:user2)     { create(:user) }
  let!(:office)    { create(:office, head: user) }
  let!(:project)   { create(:project) }

  let(:open_source_manager_user)   { create(:user, :open_source_manager) }

  describe 'Search filter' do
    context 'as admin user' do
      before do
        sign_in(admin_user)
        visit '/admin/dashboard'
      end

      it 'have user options' do
        within '#user_id_input' do
          user1_option = "#{user.name.titleize} - #{user.email} -"\
                        " #{user.office} - Não Alocado"
          user2_option = "#{user2.name.titleize} - #{user2.email} -"\
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
          expect(page).to have_text(project.name)
        end
      end
    end

    context 'as opensource manager user' do
      before do
        sign_in(open_source_manager_user)
        visit '/admin/dashboard'
      end

      it 'do not render' do
        within '#active_admin_content' do
          expect(page).to_not have_text('Campos de Busca')
        end
      end
    end
  end

  describe 'Offices Leaderboard' do
    context 'as open source manager user' do
      before do
        sign_in(open_source_manager_user)
        visit '/admin/dashboard'
      end

      it 'render for open source manager user' do
        within '#active_admin_content' do
          expect(page).to have_text('Escritórios Que Mais Contribuiram Esta Semana')
        end
      end
    end
  end
end
