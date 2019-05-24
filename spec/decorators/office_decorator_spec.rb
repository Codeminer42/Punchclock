# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OfficeDecorator do
  describe '#score' do

    context 'when score is nil' do
      subject { build_stubbed(:office, score: nil).decorate }

      it 'returns not fully evaluated message' do
        expect(subject.score).to eq(I18n.t('office.user_not_evaluated'))
      end
    end

    context 'when score is set' do
      subject { build_stubbed(:office, score: 7.5).decorate }

      it 'returns score' do
        expect(subject.score).to eq(7.5)
      end
    end
  end
end
