# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Office, type: :model do

  context 'Association' do
    it { is_expected.to have_many :users }
    it { is_expected.to have_many(:users).dependent(:restrict_with_error) }
    it { is_expected.to belong_to(:head).class_name('User').optional }
    it { is_expected.to have_and_belong_to_many :regional_holidays }
    it { is_expected.to belong_to :company }
  end

  context 'Validations' do
    subject { build(:office) }

    it { is_expected.to validate_presence_of :city }
    it { is_expected.to validate_uniqueness_of(:city).scoped_to(:company_id) }
  end

  describe '#to_s' do
    let(:office) { build :office }

    it { expect(office.to_s).to eq office.city }
  end

  describe '#calculate_score' do
    let!(:office)    { create(:office) }
    let!(:good_user) { create(:user, office: office) }
    let!(:bad_user) { create(:user, office: office) }

    context 'when its users have evaluations' do
      before do
        create(:evaluation, :english, score: 10, evaluated: good_user)
        create(:evaluation, score: 5, evaluated: good_user)
        create(:evaluation, :english, score: 7, evaluated: bad_user)
      end

      context 'and all have overall score' do
        before { create(:evaluation, score: 4, evaluated: bad_user) }

        it 'returns office average score' do
          expect(office.score).to eq(6.5)
        end
      end
    end

    context 'when its users dont have evaluations' do
      it 'set no score for office' do
        expect { office.calculate_score }.not_to change(office, :score)
      end

      it 'returns nil' do
        expect(office.score).to eq(nil)
      end
    end
  end
end
