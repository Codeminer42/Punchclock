# frozen_string_literal: true

require 'rails_helper'

describe 'Contribution', type: :feature do
  let(:admin_user) { create(:user, :super_admin, occupation: :administrative) }
  let!(:contribution) { create(:contribution, :with_valid_repository) }

  before do
    sign_in(admin_user)
    visit '/admin/contributions'
  end

  describe 'Index' do
    it 'must find fields "User", "Company", "Link" and "State" on table' do
      within 'table' do
          expect(page).to have_text('Usuário') &
                        have_text('Empresa') &
                        have_text('Link') &
                        have_text('Estado')
      end
    end
  end

  describe 'Filters' do
    it 'by user' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Usuário')
      end
    end

    it 'by company' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Empresa')
      end
    end
  end

  describe 'Actions' do
    describe 'Show' do
      before do
        within 'table' do
          find_link('Visualizar', href: "/admin/contributions/#{contribution.id}").click
        end
      end

      it 'must have labels' do
        expect(page).to have_text('Usuário') &
                        have_text('Empresa') &
                        have_text('Link') &
                        have_text('Estado') &
                        have_text('Criado em') &
                        have_text('Atualizado em')
      end

      it 'have contribution table with correct information' do
        expect(page).to have_text(contribution.user) &
                        have_text(contribution.company) &
                        have_text(contribution.link) &
                        have_text(Contribution.human_attribute_name("state/#{contribution.state}")) &
                        have_text(contribution.created_at.try(:humanize)) &
                        have_text(contribution.updated_at.try(:humanize))
      end
    end

    describe 'Approve' do
      before do
        find_link('Aprovar', href: "/admin/contributions/#{contribution.id}/approve").click
      end

      it 'updates contribution state' do
        expect(page).to have_css('.flash_notice', text: 'A contribuição foi aprovada') &
                        have_text('Aprovado')
      end
    end

    describe 'Refuse' do
      before do
        find_link('Recusar', href: "/admin/contributions/#{contribution.id}/refuse").click
      end

      it 'updates contribution state' do
        expect(page).to have_css('.flash_notice', text: 'A contribuição foi recusada') &
                        have_text('Recusado')
      end
    end
  end
end