require 'rails_helper'

RSpec.describe TalkDecorator do
  describe '#date' do
    subject { described_class.new(talk).date }

    let(:talk) { build_stubbed(:talk, date: DateTime.parse('2022-08-26T16:50')) }

    it { is_expected.to eq '26/08/2022' }
  end
end
