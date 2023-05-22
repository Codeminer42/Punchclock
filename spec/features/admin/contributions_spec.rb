require 'sidekiq/testing'
# frozen_string_literal: true

require 'rails_helper'

RSpec::Matchers.define_negated_matcher :not_have_text, :have_text

describe 'Contribution', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let!(:contribution) { create(:contribution) }
  let!(:inactive_user_contribution) { create(:contribution, :approved, user: create(:user, :inactive_user)) }

  before do
    sign_in(admin_user)
    visit '/admin/contributions'
  end

  describe 'Index' do
    it 'must find fields "User", "Link", "Created at", "State", "Pr state", "Reviewed by", "Reviewed at", "Rejected reason" on table' do
      within 'table' do
          expect(page).to have_text('Usuário') &
                        have_text('Link') &
                        have_text('Criado em') &
                        have_text('Estado') &
                        have_text('Pr State') &
                        have_text('Revisado por') &
                        have_text('Revisado em') &
                        have_text('Motivo da recusa')
      end
    end

    it 'have contribution table with correct information of active user' do
      within 'table' do
        expect(page).to have_text(contribution.user.first_and_last_name) &
                        have_text(contribution.link) &
                        have_text(I18n.l(contribution.created_at.to_date, format: :default)) &
                        have_text(Contribution.human_attribute_name("state/#{contribution.state}")) &
                        have_text(contribution.pr_state_text)
      end
    end

    it 'have contribution table without information of inactive user' do
      within 'table' do
        expect(page).to not_have_text(inactive_user_contribution.user.first_and_last_name) &
                        not_have_text(inactive_user_contribution.link) &
                        not_have_text(Contribution.human_attribute_name("state/#{inactive_user_contribution.state}"))
      end
    end

    context 'Tracking' do
      let!(:contribution) { create(:contribution, tracking: true, pending: :dev, notes: 'Note') }

      before do
        find_link('Monitorando (1)', href: "/admin/contributions?scope=tracking").click
      end

      it 'must have fields "User", "Link", "Created at", "State", "Pr state", "Reviewed by", "Reviewed at", "Rejected reason", "Pending" and "Notes" on table' do
        within 'table' do
            expect(page).to have_text('Usuário') &
                          have_text('Link') &
                          have_text('Criado em') &
                          have_text('Estado') &
                          have_text('Pr State') &
                          have_text('Revisado por') &
                          have_text('Revisado em') &
                          have_text('Motivo da recusa') &
                          have_text('Pendência') &
                          have_text('Observações')
        end
      end

      it 'have contribution table with correct information of active user' do
        within 'table' do
          expect(page).to have_text(contribution.user.first_and_last_name) &
                          have_text(contribution.link) &
                          have_text(I18n.l(contribution.created_at.to_date, format: :default)) &
                          have_text(Contribution.human_attribute_name("state/#{contribution.state}")) &
                          have_text(contribution.pr_state_text) &
                          have_text('Desenvolvedor') &
                          have_text(contribution.notes)
        end
      end
    end
  end

  describe 'Filters' do
    it 'by user' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Usuário')
      end
    end

    it 'by state' do
      within '#filters_sidebar_section' do
        expect(page).to have_select('Estado')
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
        expect(page).to have_text('Monitorar') &
                        have_text('Usuário') &
                        have_text('Link') &
                        have_text('Estado') &
                        have_text('Motivo da recusa') &
                        have_text('Pr State') &
                        have_text('Revisado por') &
                        have_text('Revisado em') &
                        have_text('Criado em') &
                        have_text('Atualizado em') &
                        have_text('Pendência') &
                        have_text('Descrição') &
                        have_text('Observações')
      end

      it 'have contribution table with correct information', :aggregate_failures do
        within "table" do
          within "tr.row.row-user" do
            expect(page).to have_text(contribution.user.name)
          end

          within "tr.row.row-link" do
            expect(page).to have_text(contribution.link)
          end

          within "tr.row.row-state" do
            expect(page).to have_text(Contribution.human_attribute_name("state/#{contribution.state}"))
          end

          within "tr.row.row-rejected_reason" do
            expect(page).to have_text('Vazio')
          end

          within "tr.row.row-pr_state" do
            expect(page).to have_text(contribution.pr_state)
          end

          within "tr.row.row-created_at" do
            expect(page).to have_text(I18n.l(contribution.created_at.to_date, format: :default))
          end

          within "tr.row.row-updated_at" do
            expect(page).to have_text(I18n.l(contribution.updated_at, format: :long))
          end
        end

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

    describe 'Refuse', js: true do
      context 'when there aren\'t errors ' do
        before do
          find(".member_link_refuse", text: 'Recusar').click
        end

        it 'shows a modal' do
          expect(page).to have_text('Justificativa') &
                          have_text('Motivo')
        end

        it 'shows rejected_reason options' do
          find_field(name: "Motivo").click

          expect(page).to have_text('Alocado no projeto') &
                          have_text('Entendimento errado da issue') &
                          have_text('Esforço insuficiente') &
                          have_text('PR abandonada') &
                          have_text('Outros')
        end

        it 'rejects a contribution' do
          find_field(name: "Motivo").click
          find_button('OK').click

          expect(page).to have_css('.flash_notice', text: 'A contribuição foi recusada') &
                          have_text('Recusado') &
                          have_text('Alocado no projeto')
        end
      end

      context 'when an error occurs' do
        before do
          find(".member_link_refuse", text: 'Recusar').click
        end

        it 'doesn\'t refuse the contribution and flashes an alert' do
          allow(Contribution).to receive(:transaction).and_raise(ActiveRecord::RecordInvalid)
          find_field(name: "Motivo").click
          find_button('OK').click

          expect(page).to have_css('.flash_alert', text: 'Não foi possível recusar a contribuição, tente novamente')
        end
      end
    end

    describe 'Edit' do
      before do
        within 'table' do
          find_link('Editar', href: "/admin/contributions/#{contribution.id}/edit").click
        end
      end

      it 'have form with "Tracking", "State", "Rejected reason", "Pending" and "Notes" fields', :aggregate_failures do
        within 'fieldset.inputs' do
          within '#contribution_tracking_input' do
            expect(page).to have_text('Monitorar')
          end

          within '#contribution_state_input' do
            expect(page).to have_text('Estado')
          end

          within '#contribution_rejected_reason_input' do
            expect(page).to have_text('Motivo da recusa')
          end

          within '#contribution_pending_input' do
            expect(page).to have_text('Pendência')
          end

          within '#contribution_description_input' do
            expect(page).to have_text('Descrição')
          end

          within '#contribution_notes_input' do
            expect(page).to have_text('Observações')
          end
        end
      end

      it 'updates tracking' do
        within '#edit_contribution' do
          page.check('Monitorar')
          find_button('Atualizar Contribuição').click
        end

        within 'tr.row.row-tracking' do
          expect(page).to have_text('Sim')
        end
      end

      it 'updates state' do
        within '#edit_contribution' do
          page.select('Aprovado', from: 'Estado*')
          find_button('Atualizar Contribuição').click
        end

        within 'tr.row.row-state' do
          expect(page).to have_text('Aprovado')
        end
      end

      it 'updates rejected_reason' do
        within '#edit_contribution' do
          page.select('Recusado', from: 'Estado*')
          page.select('Alocado no projeto', from: 'Motivo da recusa')
          find_button('Atualizar Contribuição').click
        end

        within 'tr.row.row-rejected_reason' do
          expect(page).to have_text('Alocado no projeto')
        end
      end

      it 'updates pending' do
        within '#edit_contribution' do
          page.select('Mantenedor', from: 'Pendência')
          find_button('Atualizar Contribuição').click
        end

        within 'tr.row.row-pending' do
          expect(page).to have_text('Mantenedor')
        end
      end

      it 'updates description' do
        within '#edit_contribution' do
          page.fill_in('Descrição', with: 'some description')
          find_button('Atualizar Contribuição').click
        end

        within 'tr.row.row-description' do
          expect(page).to have_text('some description')
        end
      end

      it 'updates notes' do
        within '#edit_contribution' do
          page.fill_in('Observações', with: 'some notes')
          find_button('Atualizar Contribuição').click
        end

        within 'tr.row.row-notes' do
          expect(page).to have_text('some notes')
        end
      end
    end
  end
end
