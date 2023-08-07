# frozen_string_literal: true

RSpec.describe 'Regional holidays' do
  describe 'index' do
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

      describe 'pagination' do
        let(:maximum_per_page) { 2 }

        before do
          visit "/new_admin/regional_holidays?per=#{maximum_per_page}"
        end

        it 'displays the maximum holidays in each page', :aggregate_failure do
          within_table 'index_table_regional_holidays' do
            expect(page).to have_css('tbody tr', count: maximum_per_page)
          end

          within '#pagination_regional_holidays' do
            click_link '2'
          end

          within_table 'index_table_regional_holidays' do
            expect(page).to have_css('tbody tr', count: maximum_per_page)
          end
        end
      end
    end
  end

  describe 'show' do
    let(:city) { create(:city, name: 'London') }
    let!(:holiday) { create(:regional_holiday, cities: [city], day: 26, month: 12, name: 'Boxing Day') }

    let(:admin) { create(:user, :admin, occupation: :administrative) }

    before do
      sign_in(admin)
      visit "/new_admin/regional_holidays/#{holiday.id}"
    end

    it "shows holiday's details" do
      within "#details_table_regional_holidays" do
        expect(page).to have_css('tbody tr', count: 5) &&
                        have_content('London') &&
                        have_content(holiday.day) &&
                        have_content(holiday.month) &&
                        have_content('Boxing Day') &&
                        have_content(holiday.id)
      end
    end

    it "shows actions for holiday" do
      within "#regional_holiday_actions" do
        expect(page).to have_link("Editar Feriado Regional") &&
                        have_link("Remover Feriado Regional")
      end
    end
  end

  describe 'new' do
    let!(:city) { create(:city, name: 'London') }
    let(:admin) { create(:user, :admin, occupation: :administrative) }

    before do
      sign_in(admin)
      visit '/new_admin/regional_holidays/new'
    end

    it 'shows form fields' do
      within "#form_regional_holiday" do
        expect(page).to have_content(RegionalHoliday.human_attribute_name('name')) &&
                        have_content(RegionalHoliday.human_attribute_name('day')) &&
                        have_content(RegionalHoliday.human_attribute_name('month')) &&
                        have_content(RegionalHoliday.human_attribute_name('cities')) &&
                        have_select
      end

      expect(page).to have_button(I18n.t('form.button.submit'))
    end

    it 'creates regional holiday' do
      within "#form_regional_holiday" do
        fill_in 'regional_holiday_name', with: 'Foobar Holiday'
        fill_in 'regional_holiday_day', with: 1
        fill_in 'regional_holiday_month', with: 12
        select city.name, from: 'regional_holiday_city_ids'
      end

      click_button I18n.t('form.button.submit')

      expect(page).to have_content(
        I18n.t(:notice, scope: "flash.actions.create",
                        resource_name: RegionalHoliday.model_name.human)
      )
    end
  end

  describe 'edit' do
    let(:city) { create(:city, name: 'London') }
    let!(:holiday) { create(:regional_holiday, cities: [city], day: 26, month: 12, name: 'Boxing Day') }

    let(:admin) { create(:user, :admin, occupation: :administrative) }

    before do
      sign_in(admin)
      visit "/new_admin/regional_holidays/#{holiday.id}/edit"
    end

    it "shows form fields" do
      within "#form_regional_holiday" do
        expect(page).to have_content(RegionalHoliday.human_attribute_name('name')) &&
                        have_content(RegionalHoliday.human_attribute_name('day')) &&
                        have_content(RegionalHoliday.human_attribute_name('month')) &&
                        have_content(RegionalHoliday.human_attribute_name('cities')) &&
                        have_select
      end

      expect(page).to have_button(I18n.t('form.button.submit'))
    end

    it 'updates regional holiday', :aggregate_failures do
      new_name = 'Foobar Holiday'

      within "#form_regional_holiday" do
        fill_in 'regional_holiday_name', with: new_name
      end

      click_button I18n.t('form.button.submit')

      expect(page).to have_content(
        I18n.t(:notice, scope: "flash.actions.update",
                        resource_name: RegionalHoliday.model_name.human)
      )
      expect(holiday.reload.name).to eq(new_name)
    end
  end

  describe 'destroy' do
    let(:city) { create(:city, name: 'London') }
    let!(:holiday) { create(:regional_holiday, cities: [city], day: 26, month: 12, name: 'Boxing Day') }

    let(:admin) { create(:user, :admin, occupation: :administrative) }

    before do
      sign_in(admin)
    end

    context 'when user deletes holiday from index page' do
      before { visit "/new_admin/regional_holidays" }

      it 'destroys record', :aggregate_failures do
        within "#regional_holiday_#{holiday.id}" do
          expect do
            click_link I18n.t('delete')
          end.to change(RegionalHoliday, :count).from(1).to(0)
        end

        expect(page).to have_content(
          I18n.t(:notice, scope: "flash.actions.destroy",
                          resource_name: RegionalHoliday.model_name.human)
        )
      end
    end

    context 'when user deletes holiday from show page' do
      before { visit "/new_admin/regional_holidays/#{holiday.id}" }

      it 'destroys record', :aggregate_failures do
        within '#regional_holiday_actions' do
          expect do
            click_link I18n.t('new_admin.regional_holidays.show.destroy')
          end.to change(RegionalHoliday, :count).from(1).to(0)
        end

        expect(page).to have_content(
          I18n.t(:notice, scope: "flash.actions.destroy",
                          resource_name: RegionalHoliday.model_name.human)
        )
      end
    end
  end
end
