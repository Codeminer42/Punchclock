# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Talking, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to :user }
  end

  describe 'validations' do
    subject(:invalid_talking) { build(:talking, :invalid_talking) }

    before do
      invalid_talking.validate
    end

    describe '#event_name' do
      describe 'when event_name is not present' do
        it 'is expected to return an error message' do
          expect(invalid_talking.errors[:event_name]).to contain_exactly('não pode ficar em branco')
        end
      end
    end

    describe '#talk_title' do
      describe 'when talk_title is not present' do
        it 'is expected to return an error message' do
          expect(invalid_talking.errors[:talk_title]).to contain_exactly('não pode ficar em branco')
        end
      end
    end

    describe '#date' do
      describe 'when date is not present' do
        it 'is expected to return an error message' do
          expect(invalid_talking.errors[:date]).to contain_exactly("não pode ficar em branco")
        end
      end

      describe 'when date is in the future' do
        subject(:with_future_date) { build(:talking, :with_future_date) }

        it 'is expected to return an error message' do
          with_future_date.validate

          expect(with_future_date.errors[:date]).to contain_exactly("must be before the today's date")
        end
      end
    end

    describe 'when all attributes are correct' do
      subject(:valid_talking) { build(:talking) }

      it 'is expected to return no errors' do
        valid_talking.validate

        expect(valid_talking.errors.to_a).to eq([])
      end
    end
  end
end
