# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllocationsSpreadsheet do
  context 'when user has mentor' do
    let(:mentor) { create(:user, name: 'Gabriel', email: 'gabriel@code.com') }
    let(:user) { create(:user, name: 'Philipe', email: 'philipe@code.com', mentor:) }
    let(:project) { create(:project, name: 'Punchclock') }
    let(:allocation) { create(:allocation, user:, project:, end_at: 10.days.from_now) }

    let(:allocation_spreadsheet) { AllocationsSpreadsheet.new([allocation]) }
    let(:header_attributes) do
      [
        User.human_attribute_name('name'),
        User.human_attribute_name('email'),
        I18n.t('allocation.project_name'),
        I18n.t('allocation.mentor_name'),
        I18n.t('allocation.mentor_email')
      ]
    end

    let(:body_attributes) do
      [
        'Philipe',
        'philipe@code.com',
        'Punchclock',
        'Gabriel',
        'gabriel@code.com'
      ]
    end

    describe '#to_string_io' do
      subject(:to_string_io) do
        allocation_spreadsheet.to_string_io
      end

      before do
        File.open('/tmp/spreadsheet_temp.xlsx', 'wb') { |f| f.write(subject) }
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

  context 'when user has no mentor' do
    let(:user) { create(:user, name: 'Philipe', email: 'philipe@code.com') }
    let(:project) { create(:project, name: 'Punchclock') }
    let(:allocation) { create(:allocation, user:, project:, end_at: 10.days.from_now) }
    let(:allocation_spreadsheet) { AllocationsSpreadsheet.new([allocation]) }
    let(:header_attributes) do
      [
        User.human_attribute_name('name'),
        User.human_attribute_name('email'),
        I18n.t('allocation.project_name'),
        I18n.t('allocation.mentor_name'),
        I18n.t('allocation.mentor_email')
      ]
    end

    let(:body_attributes) do
      [
        'Philipe',
        'philipe@code.com',
        'Punchclock',
        '-',
        '-'
      ]
    end

    describe '#body' do
      subject { allocation_spreadsheet.body(allocation) }

      it 'return body data' do
        is_expected.to containing_exactly(*body_attributes)
      end
    end
  end
end
