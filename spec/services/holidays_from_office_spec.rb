require 'rails_helper'

RSpec.describe HolidaysFromOffice do
  let(:company) { build_stubbed(:company) }
  let(:regional_holiday) { build_stubbed(:regional_holiday, company: company) }
  let(:office_with_regional_holidays) { build_stubbed(:office, company: company) }
  let(:office_without_regional_holidays) { build_stubbed(:office) }


  describe '.holidays_from_office' do
    context 'office with all holidays' do
      subject(:service) { HolidaysFromOffice.perform(office_with_regional_holidays) }

      it 'should returns the holidays' do
        expect(office_with_regional_holidays.holidays).to eq(service)
      end
    end

    context 'office without holidays' do
      subject(:service) { HolidaysFromOffice.perform(office_without_regional_holidays) }

      it 'should return just national holidays' do
        expect(office_without_regional_holidays.holidays).to eq(service)
      end
    end
  end
end
