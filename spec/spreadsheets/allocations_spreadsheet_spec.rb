# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllocationsSpreadsheet do
  let(:office_head) { create(:user, name: 'Wender') }
  let(:office) { create(:office, head: office_head) }
  let(:user) { create(:user, name: 'Philipe', specialty: 'backend', office: office) }
  let(:project) { create(:project, name: 'Punchclock') }
  let(:allocation) { create(:allocation, user: user, project: project, end_at: 10.days.from_now) }

  let(:allocation_spreadsheet) { AllocationsSpreadsheet.new([allocation]) }
  let(:header_attributes) do
    [
      User.human_attribute_name('name'),
      User.human_attribute_name('specialty'),
      Office.human_attribute_name('head'),
      Allocation.human_attribute_name('project'),
      Allocation.human_attribute_name('end_at')
    ]
  end

  let(:body_attributes) do
    [
      'Philipe',
      'backend',
      'Punchclock',
      'Wender',
      I18n.l(10.days.from_now, format: '%d de %B de %Y')
    ]
  end

  describe '#to_string_io' do
    subject do
      allocation_spreadsheet
        .to_string_io
        .force_encoding('iso-8859-1')
        .encode('utf-8')
    end

    it 'returns spreadsheet data' do
      is_expected.to include(*body_attributes)
    end

    it 'returns spreadsheet with header' do
      is_expected.to include(*header_attributes)
    end
  end

  describe '#generate_xls' do
    subject(:spreadsheet) { allocation_spreadsheet.generate_xls }

    it 'returns spreadsheet object with header' do
      expect(spreadsheet.row(0)).to containing_exactly(*header_attributes)
    end

    it 'returns spreadsheet object with body' do
      expect(spreadsheet.row(1)).to containing_exactly(*body_attributes)
    end
  end

  describe '#body' do
    subject { allocation_spreadsheet.body(allocation) }

    it 'return body data' do
      is_expected.to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject { allocation_spreadsheet.header }

    it 'returns header data' do
      is_expected.to containing_exactly(*header_attributes)
    end
  end
end
