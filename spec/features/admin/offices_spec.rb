# frozen_string_literal: true

require 'rails_helper'

describe 'Offices', type: :feature do
  let(:admin_user) { create(:admin_user) }
  let(:office)     { create(:office, company: admin_user.company) }
  let!(:user)      { create(:user,
                            :with_overall_score,
                            :admin,
                            office: office,
                            company: admin_user.company) }

  before do
    admin_sign_in(admin_user)
    visit '/admin/offices'
  end

  describe 'Index' do
    it 'must find fields "Office", "Users" and "Score" on table' do
      within 'table' do
        expect(page).to have_text('Cidade') &
                        have_text('Head') &
                        have_text('Quantidade de usuários') &
                        have_text('Pontuação')
      end
    end
  end

  describe 'Filters' do
    it 'by city' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Cidade', options: admin_user.company.offices.pluck(:city) << 'Qualquer')
      end
    end

    it 'by head' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Head', options: admin_user.company.users.pluck(:name) << 'Qualquer')
      end
    end
  end

  describe 'Actions' do
    describe 'New' do
      before do
        within '.action_items' do
          click_link 'Novo(a) Escritório'
        end
      end

      it 'must have the form working' do
        find('#office_head_id').find(:option, user.name).select_option
        find('#office_city').fill_in with: 'São Francisco'

        click_button 'Criar Escritório'

        expect(page).to have_text('Escritório foi criado com sucesso.') &
                        have_text('São Francisco') &
                        have_text(user.name) &
                        have_text(I18n.t('office.user_not_evaluated'))
      end
    end

    describe 'Show' do
      before do
        visit '/admin/offices'
        within 'table' do
          find_link(office.city, href: "/admin/offices/#{office.id}").click
        end
      end

      it 'have edit action' do
        expect(page).to have_link('Editar Escritório')
      end

      it 'have delete action' do
        expect(page).to have_link('Remover Escritório')
      end

      it 'must have labels' do
        within '.attributes_table.office' do
          expect(page).to have_text('Cidade') &
                          have_text('Head') &
                          have_text('Quantidade de usuários') &
                          have_text('Pontuação')

        end
      end

      it 'have user table with correct information' do
        expect(page).to   have_text(user.name) &
                          have_text(user.email) &
                          have_text(user.occupation) &
                          have_text(user.overall_score)
      end
    end

    describe 'Edit' do
      before do
        visit "/admin/offices/#{office.id}"
        click_link('Editar Escritório')
      end

      it 'must have labels' do
        within 'form' do
          expect(page).to have_text('Office') &
                          have_text('Head')
        end
      end

      it 'updates office information' do
        find('#office_city').fill_in with: 'Curitiba'

        click_button 'Atualizar Escritório'

        expect(page).to have_css('.flash_notice', text: 'Escritório foi atualizado com sucesso.') &
                        have_text('Curitiba') &
                        have_text(office.score)
      end
    end

    describe 'Destroy' do
      let!(:office_without_users) { create(:office, company: admin_user.company) }

      it 'cancel delete office', js: true do
        visit "/admin/offices/#{office_without_users.id}"

        page.dismiss_confirm do
          find_link("Remover Escritório", href: "/admin/offices/#{office_without_users.id}").click
        end

        expect(current_path).to eql("/admin/offices/#{office_without_users.id}")
      end

      it 'confirm delete office', js: true do
        visit "/admin/offices/#{office_without_users.id}"

        page.accept_confirm do
          find_link("Remover Escritório", href: "/admin/offices/#{office_without_users.id}").click
        end

        expect(page).to have_text('Escritório foi deletado com sucesso.') &
                        have_no_link(office_without_users.city, href: "/admin/offices/#{office_without_users.id}")
      end

      it 'deny delete office with users', js: true do
        visit "/admin/offices/#{office.id}"

        page.accept_confirm do
          find_link("Remover Escritório", href: "/admin/offices/#{office.id}").click
        end

        expect(page).to have_text('Escritório não pôde ser deletado.') &
                        have_link(office.city, href: "/admin/offices/#{office.id}")
      end
    end
  end
end
