require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to :author }
    it { is_expected.to belong_to :user }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to enumerize(:rate).in(%i[bad neutral good]) }
  end

  describe '#by_title_like' do
    let!(:first_note) { create(:note, title: 'TheFirstNote') }
    let!(:second_note) { create(:note, title: 'TheSecondNote') }

    it 'filter note by its title' do
      expect(described_class.by_title_like('first')).to contain_exactly(first_note)
    end

    context 'when no title is given' do
      it 'matches all notes' do
        expect(described_class.by_title_like(nil)).to contain_exactly(first_note, second_note)
      end
    end
  end

  describe '#by_user' do
    let!(:first_note) { create(:note) }
    let!(:second_note) { create(:note) }

    it 'filters notes by user_id' do
      expect(described_class.by_user(first_note.user_id)).to contain_exactly(first_note)
    end

    context 'when no user_id is given' do
      it 'matches all notes' do
        expect(described_class.by_user(nil)).to contain_exactly(first_note, second_note)
      end
    end
  end

  describe '#by_author' do
    let!(:first_note) { create(:note) }
    let!(:second_note) { create(:note) }

    it 'filters notes by author_id' do
      expect(described_class.by_author(first_note.author_id)).to contain_exactly(first_note)
    end

    context 'when no user_id is given' do
      it 'matches all notes' do
        expect(described_class.by_author(nil)).to contain_exactly(first_note, second_note)
      end
    end
  end

  describe '#by_rate' do
    let!(:good_note) { create(:note, rate: 'good') }
    let!(:bad_note) { create(:note, rate: 'bad') }

    it 'filters notes by rate' do
      expect(described_class.by_rate('good')).to contain_exactly(good_note)
    end

    context 'when no rate is given' do
      it 'matches all notes' do
        expect(described_class.by_rate(nil)).to contain_exactly(good_note, bad_note)
      end
    end
  end
end
