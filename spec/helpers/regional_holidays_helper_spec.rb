require 'spec_helper'

describe RegionalHolidaysHelper do
  context '#parameterize_holidays' do
    it 'with a holiday that happens on june 17th' do
      holiday = [ double('holiday', month: 6, day: 17) ]

      result =  helper.parameterize_holidays(holiday)
      
      expect(result).to contain_exactly([6, 17])
    end
  end
end
