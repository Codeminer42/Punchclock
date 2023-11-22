require 'rails_helper'

RSpec.describe NewAdmin::NotesQuery do
  describe '#self.call' do
    context 'when no filters are applied' do
      let(:notes) { create_list(:note, 2) }

      it 'retrieves the notes' do
        expect(described_class.call({})).to match_array(notes)
      end
    end

    context 'when filters are applied' do
      let!(:first_note) { create(:note, title: 'first_note') }
      let!(:second_note) {create(:note, title: 'second_note')}

      it 'retrieves filtered projects' do
        filters = { title: 'first' }

        expect(described_class.call(filters)).to match_array(first_note)
      end
    end
  end
end