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
      'Wender',
      'Punchclock',
      I18n.l(10.days.from_now, format: '%d de %B de %Y')
    ]
  end

  describe '#to_string_io' do
    subject(:to_string_io) do
      allocation_spreadsheet.to_string_io
    end

    before do
      File.open('/tmp/spreadsheet_temp.xlsx', 'wb') {|f| f.write(subject) }
    end

    it_behaves_like 'a valid spreadsheet'
    it_behaves_like 'a spreadsheet with header and body'
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
