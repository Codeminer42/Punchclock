require 'rails_helper'

describe 'Dashboard', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let!(:user)      { create(:user) }
  let!(:user2)     { create(:user) }
  let!(:office)    { create(:office, head: user) }
  let!(:project)   { create(:project) }

  let(:open_source_manager_user)   { create(:user, :open_source_manager) }

  before do
    create(:user, :with_overall_score, :level_intern, score: 8)
    create(:user, :with_overall_score, :level_intern, score: 3)
    create(:user, :with_overall_score, :level_junior, score: 7)
    create(:user, :with_overall_score, :level_junior, score: 9)
    create(:user, :with_overall_score, :level_junior_plus, score: 1)
    create(:user, :with_overall_score, :level_junior_plus, score: 5)
    create(:user, :with_overall_score, :level_mid, score: 8)
    create(:user, :with_overall_score, :level_mid, score: 6)
    create(:user, :with_overall_score, :level_mid_plus, score: 3)
    create(:user, :with_overall_score, :level_mid_plus, score: 1)
    create(:user, :with_overall_score, :level_senior, score: 7)
    create(:user, :with_overall_score, :level_senior, score: 8)
    create(:user, :with_overall_score, :level_senior_plus, score: 9)
    create(:user, :with_overall_score, :level_senior_plus, score: 9)
  end

  describe 'Search filter' do
    context 'as admin user' do
      before do
        sign_in(admin_user)
        visit '/admin/dashboard'
      end

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

  describe 'Score average' do
    context 'as admin user' do
      before do
        sign_in(admin_user)
        visit '/admin/dashboard'
      end

      it 'have trainee average' do
        row = find("tr", text: "Intern")
        within row do
          expect(page).to have_text(5.5)
        end
      end

      it 'have junior average' do
        row = find("tr", text: /Junior [0-9]+/)
        within row do
          expect(page).to have_text(8)
        end
      end

      it 'have junior_plus average' do
        row = find("tr", text: "Junior plus")
        within row do
          expect(page).to have_text(3)
        end
      end

      it 'have mid average' do
        row = find("tr", text: /Mid [0-9]+/)
        within row do
          expect(page).to have_text(7)
        end
      end

      it 'have mid_plus average' do
        row = find("tr", text: "Mid plus")
        within row do
          expect(page).to have_text(2)
        end
      end

      it 'have senior average' do
        row = find("tr", text: /Senior [0-9]+/)
        within row do
          expect(page).to have_text(7.5)
        end
      end

      it 'have senior_plus average' do
        row = find("tr", text: "Senior plus")
        within row do
          expect(page).to have_text(9)
        end
      end
    end

    context 'as open source manager user' do
      before do
        sign_in(open_source_manager_user)
        visit '/admin/dashboard'
      end

      it 'do not render' do
        within '#active_admin_content' do
          expect(page).to_not have_text('Média De Engenheiros Por Nível')
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
