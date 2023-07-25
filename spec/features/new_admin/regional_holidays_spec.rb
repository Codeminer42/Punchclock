# frozen_string_literal: true

RSpec.describe 'Regional holidays' do
  let(:admin) { create(:user, :admin, occupation: :administrative) }

  let(:new_york)    { create(:city, name: 'New York') }
  let(:los_angeles) { create(:city, name: 'Los Angeles') }
  let(:miami)       { create(:city, name: 'Miami') }
  let(:chicago)     { create(:city, name: 'Chicago') }
  let(:san_diego)   { create(:city, name: 'San Diego') }

  let!(:pizza_day) do
    create(:regional_holiday, cities: [new_york], day: 9, month: 2, name: 'Pizza Day')
  end
  let!(:unicorn_parade) do
    create(:regional_holiday, cities: [los_angeles, san_diego], day: 17, month: 6, name: 'Unicorn Parade')
  end
  let!(:jellybean_jamboree) do
    create(:regional_holiday, cities: [miami], day: 7, month: 4, name: 'Jellybean Jamboree')
  end
  let!(:doughnut_olympics) do
    create(:regional_holiday, cities: [chicago], month: 6, name: 'Doughnut Olympics')
  end

  before do
    sign_in(admin)
  end

  describe 'Filters' do
    before do
      visit '/new_admin/regional_holidays'
    end

    context 'by holiday' do
      it 'shows filtered regional holidays' do
        within '#filters_sidebar_section' do
          expect(page).to have_select('regional_holiday_id', options: RegionalHoliday.pluck(:name) << 'Qualquer')

          select unicorn_parade.name, from: 'regional_holiday_id'
          click_button 'Filtrar'
        end

        within_table 'index_table_regional_holidays' do
          expect(page).to have_css('tbody tr', count: 1) and
            have_selector("#regional_holiday_#{unicorn_parade.id}", count: 1) and
            have_no_selector("#regional_holiday_#{pizza_day.id}") and
            have_no_selector("#regional_holiday_#{jellybean_jamboree.id}") and
            have_no_selector("#regional_holiday_#{doughnut_olympics.id}")
        end
      end
    end

    context 'by cities' do
      it 'shows regional holidays filtered by cities' do
        within '#filters_sidebar_section' do
          expect(page).to have_select('city_ids[]', options: City.joins(:regional_holidays).distinct.pluck(:name))

          [miami, chicago].each do |city|
            find('option', text: city.name).select_option
          end

          click_button 'Filtrar'
        end

        within_table 'index_table_regional_holidays' do
          expect(page).to have_css('tbody tr', count: 2) and
            have_selector("#regional_holiday_#{jellybean_jamboree.id}", count: 1) and
            have_selector("#regional_holiday_#{doughnut_olympics.id}", count: 1) and
            have_no_selector("#regional_holiday_#{pizza_day.id}") and
            have_no_selector("#regional_holiday_#{unicorn_parade.id}")
        end
      end
    end

    context 'by month' do
      it 'shows regional holidays filtered by month' do
        within '#filters_sidebar_section' do
          expect(page).to have_select('month', options: I18n.t('date.month_names').compact << 'Qualquer')

          select 'junho', from: 'month'

          click_button 'Filtrar'
        end

        within_table 'index_table_regional_holidays' do
          expect(page).to have_css('tbody tr', count: 2) and
            have_selector("#regional_holiday_#{unicorn_parade.id}", count: 1) and
            have_selector("#regional_holiday_#{doughnut_olympics.id}", count: 1) and
            have_no_selector("#regional_holiday_#{pizza_day.id}") and
            have_no_selector("#regional_holiday_#{jellybean_jamboree.id}")
        end
      end
    end

    context 'with no filter selected' do
      it 'shows all regional holidays' do
        within_table 'index_table_regional_holidays' do
          expect(page).to have_css('tbody tr', count: 4) and
            have_selector("#regional_holiday_#{unicorn_parade.id}", count: 1) and
            have_selector("#regional_holiday_#{doughnut_olympics.id}", count: 1) and
            have_selector("#regional_holiday_#{pizza_day.id}", count: 1) and
            have_selector("#regional_holiday_#{jellybean_jamboree.id}", count: 1)
        end
      end
    end

    context 'when no regional holiday is found' do
      it 'shows "No regional holiday found" message' do
        within '#filters_sidebar_section' do
          expect(page).to have_select('month', options: I18n.t('date.month_names').compact << 'Qualquer')

          select 'janeiro', from: 'month'

          click_button 'Filtrar'
        end

        expect(page).to have_content('Nenhum feriado regional encontrado')
      end
    end
  end
end