# frozen_string_literal: true

require 'rails_helper'

describe 'Admin Allocation chart', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let(:company) { admin_user.company }

  before do
    sign_in(admin_user)
  end

  describe 'Index' do
    let(:project) { create(:project, company: company) }
    let!(:user) { create(:user, allocations: [build(:allocation, project: project, company: company)], company: company) }

    before { visit '/admin/allocation_chart' }

    it 'have table with fields "Nome", "Habilidades", "Cliente", "Alocado até"' do
      within 'table' do
        aggregate_failures 'testing table fields' do
          expect(page).to have_text('Nome')
          expect(page).to have_text('Habilidades')
          expect(page).to have_text('Cliente')
          expect(page).to have_text('Alocado até')
        end
      end
    end

    context 'table row' do
      it 'links to user show page' do
        within 'table' do
          expect(page).to have_link(user.name, href: "/admin/users/#{user.id}")
        end
      end

      it 'links to user current project' do
        within 'table' do
          expect(page).to have_link(project.name, href: "/admin/projects/#{project.id}")
        end
      end
    end
  end
end
