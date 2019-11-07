# frozen_string_literal: true

require 'rails_helper'
require_relative '../../app/helpers/punches_helper'

RSpec.describe PunchesSpreadsheet do
  let(:punch) { create(:punch, comment: 'punch test').decorate }
  let!(:punch_spreadsheet) { PunchesSpreadsheet.new([punch]) }
  let(:header_attributes) do
    [
      Punch.human_attribute_name('project'),
      User.human_attribute_name('name'),
      Punch.human_attribute_name('when'),
      Punch.human_attribute_name('from'),
      Punch.human_attribute_name('to'),
      Punch.human_attribute_name('delta'),
      Punch.human_attribute_name('extra_hour'),
      Punch.human_attribute_name('comment')
    ]
  end

  let(:body_attributes) do
    [punch.user.name,
     punch.project.name,
     punch.when,
     punch.from,
     punch.to,
     punch.delta,
     I18n.t(punch.extra_hour),
     punch.comment]
  end

  # Draper gem not loading helper functions
  # related issue: https://github.com/drapergem/draper/issues/655
  # solution: https://github.com/drapergem/draper/issues/655#issuecomment-158594585
  before { Draper::ViewContext.clear! }

  describe '#to_string_io' do
    subject do
      punch_spreadsheet
        .to_string_io
        .force_encoding('iso-8859-1')
        .encode('utf-8')
    end

    it 'returns spreadsheet data' do
      is_expected.to include(punch.user.name,
                             punch.project.name,
                             punch.when,
                             punch.from,
                             punch.to,
                             punch.delta,
                             I18n.t(punch.extra_hour),
                             punch.comment)
    end

    it 'returns spreadsheet with header' do
      is_expected.to include(Punch.human_attribute_name('project'),
                             Punch.human_attribute_name('when'),
                             Punch.human_attribute_name('from'),
                             Punch.human_attribute_name('to'),
                             Punch.human_attribute_name('delta'),
                             Punch.human_attribute_name('extra_hour'),
                             Punch.human_attribute_name('comment'))
    end
  end

  describe '#body' do
    subject { punch_spreadsheet.body(punch) }

    it 'returns body data' do
      is_expected.to containing_exactly(*body_attributes)
    end
  end

  describe '#generate_xls' do
    subject(:spreadsheet) { punch_spreadsheet.generate_xls }

    it 'returns spreadsheet object with header' do
      expect(spreadsheet.row(0)).to containing_exactly(*header_attributes)
    end

    it 'returns spreadsheet object with body' do
      expect(spreadsheet.row(1)).to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject { punch_spreadsheet.header }

    it 'returns header data' do
      is_expected.to containing_exactly(*header_attributes)
    end
  end
end
