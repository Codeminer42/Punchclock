# frozen_string_literal: true

require 'rails_helper'

describe 'Vacation', type: :feature do
  let(:admin) { create(:user, :admin, :commercial) }
  let!(:vacation) { create(:vacation) }

  before do
    sign_in(admin)
    visit 'admin/vacations'
  end

  describe 'Index' do
    it 'must find fields "Usuário", "Data de início", "Data de término", "Status", "Aprovação Comercial", "Aprovação Administrativa" on table' do
      within 'table' do
        expect(page).to have_text('Usuário') &
                        have_text('Data de início') &
                        have_text('Data de término') &
                        have_text('Status') &
                        have_text('Aprovação Comercial') &
                        have_text('Aprovação Administrativa')
      end
    end

    it 'must find correct information for vacations' do
      within 'table' do
        expect(page).to have_text(vacation.user.name) &
                        have_text(l(vacation.start_date, format: :default)) &
                        have_text(l(vacation.end_date, format: :default)) &
                        have_text(Vacation.human_attribute_name("status/#{vacation.status}"))
      end
    end
  end

  describe 'Filters' do
    it 'by start date' do
      within '#filters_sidebar_section' do
        expect(page).to have_text('Data de início')
      end
    end

    it 'by end date' do
      within '#filters_sidebar_section' do
        expect(page).to have_text('Data de término')
      end
    end

    it 'by end date' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Usuário')
      end
    end
  end

  describe 'Actions' do
    describe 'Aprovar' do
      before do
        within 'table' do
          find_link('Aprovar', href: "/admin/vacations/#{vacation.id}/approve").click
        end
      end

      it 'have vacation with commercial approver' do
        within 'td.col-commercial_approver' do
          expect(page).to have_text(admin.name)
        end
      end

      it 'have vacation with administrative approver' do
        within 'td.col-administrative_approver' do
          expect(page).to have_text(admin.name)
        end
      end

      it 'have status approved' do
        within 'td.col-status' do
          expect(page).to have_text('Aprovada')
        end
      end
    end

    describe 'Recusar' do
      before do
        within 'table' do
          find_link('Recusar', href: "/admin/vacations/#{vacation.id}/denied").click
        end
      end

      it 'have vacation with commercial approver' do
        within 'td.col-commercial_approver' do
          expect(page).to have_text(admin.name)
        end
      end

      it 'have vacation with administrative approver' do
        within 'td.col-administrative_approver' do
          expect(page).to have_text(admin.name)
        end
      end

      it 'have status denied' do
        within 'td.col-status' do
          expect(page).to have_text('Negada')
        end
      end
    end
  end
end
