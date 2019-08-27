require 'rails_helper'
require_relative '../../app/helpers/punches_helper'

RSpec.describe PunchesSpreadsheet do
  let!(:punch) { create(:punch, comment: 'punch test').decorate }  

  describe '#initialize' do
    subject { PunchesSpreadsheet.new([punch]) }

    it 'should respond to method' do
      is_expected.to respond_to(:generate_xls)
    end
  end

  describe '#generate_xls' do
    subject do
      PunchesSpreadsheet.new([punch])
                        .generate_xls
                        .force_encoding('iso-8859-1')
                        .encode('utf-8')
    end
  
    # Draper gem not loading helper functions
    # related issue: https://github.com/drapergem/draper/issues/655
    # solution: https://github.com/drapergem/draper/issues/655#issuecomment-158594585
    before { Draper::ViewContext.clear! }

    it 'return spreadsheet data' do      
      is_expected.to match(punch.user.name) &
                     match(punch.project.name) &
                     match(punch.when) &
                     match(punch.from) &
                     match(punch.to) &
                     match(punch.delta) &
                     match(I18n.t(punch.extra_hour)) &
                     match(punch.comment)
     end 
  end
end
