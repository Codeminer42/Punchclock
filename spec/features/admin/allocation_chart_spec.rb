# frozen_string_literal: true

require 'rails_helper'

describe 'Admin Allocation chart', type: :feature do
  let(:next_month_date) { Date.today.next_month }
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }

  before do
    sign_in(admin_user)
  end

  describe 'Index' do
    let(:project) { create(:project) }
    let!(:user) { create(:user, allocations: [allocation]) }

    let(:allocation) do
      build(:allocation, project: project, start_at: Date.today.prev_month, end_at: next_month_date, ongoing: true)
    end

    before { visit '/admin/allocation_chart' }

    it 'have table with fields "Nome", "Habilidades", "Especialidade", "Nível", "Cliente", "Alocado até"' do
      within 'table' do
        aggregate_failures 'testing table fields' do
          expect(page).to have_text('Nome')
          expect(page).to have_text('Habilidades')
          expect(page).to have_text('Nível de Backend')
          expect(page).to have_text('Nível de Frontend')
          expect(page).to have_text('Cliente')
          expect(page).to have_text('Alocado até')
        end
      end
    end

    context 'table row' do
      context 'when allocated' do
        it 'links to user show page' do
          within 'table' do
            expect(page).to have_link(user.first_and_last_name, href: "/admin/users/#{user.id}")
          end
        end

        it 'links to user current project' do
          within 'table' do
            expect(page).to have_link(project.name, href: "/admin/projects/#{project.id}")
          end
        end

        it '"Alocado até" column links to allocation' do
          within 'tbody' do
            formatted_date = next_month_date.strftime('%d/%m/%Y')
            expect(page).to have_link(formatted_date, href: "/admin/allocations/#{allocation.id}")
          end
        end
      end

      context 'when not allocated' do
        let(:allocation) do
          build(:allocation, project: project, start_at: Date.new(2022, 5, 1), end_at: Date.new(2022, 11, 1), ongoing: false)
        end

        it 'has "Não alocado" in "Alocado até" column' do
          within 'tbody' do
            expect(page).to have_text('Não alocado')
          end
        end

        it '"Alocado até" column does not links to allocation' do
          within 'table' do
            expect(page).to have_no_link('Não alocado')
          end
        end
      end
    end
  end
end
