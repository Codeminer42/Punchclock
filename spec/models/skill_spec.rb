# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Skill, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:user_skills) }
    it { is_expected.to have_many(:users).through(:user_skills) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
  end

  describe 'scopes' do

    describe '#by_title_like' do
      let!(:skill1) { create(:skill, title: 'foo') }
      let!(:skill2) { create(:skill, title: 'bar') }

      context 'when title is present' do
        it 'filters skills by title' do
          expect(Skill.by_title_like('ba')).to contain_exactly(skill2)
        end
      end

      context 'when title is not present' do
        it 'does not filter by title' do
          expect(Skill.by_title_like(nil)).to contain_exactly(skill1, skill2)
        end
      end
    end
  end
end
