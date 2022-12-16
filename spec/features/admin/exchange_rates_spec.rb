# frozen_string_literal: true

require 'rails_helper'

describe 'Exchange Rates', type: :feature do
  let(:admin_user) { create(:user, :admin, occupation: :administrative) }
  let!(:exchange_rate) { create(:exchange_rate) }

  before do
    sign_in(admin_user)
    visit '/admin/exchange_rates'
  end

  describe 'Index' do
    it 'must find fields "Mês", "Ano", "Moeda" and "Taxa" on table' do
      within 'table' do
        expect(page).to have_text('Ano') &
                        have_text('Moeda') &
                        have_text('Taxa')
      end
    end
  end

  describe 'Filters' do
    it 'by year' do
      within '#filters_sidebar_section' do
        expect(page).to have_css('label', text: 'Year equals')
      end
    end

    it 'by currency' do
      within '#filters_sidebar_section' do
        expect(page).to have_css('label', text: 'Moeda')
      end
    end
  end
end
