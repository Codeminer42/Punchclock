require 'rails_helper'

describe Office do
  it { is_expected.to have_many :users }
  it { is_expected.to have_and_belong_to_many :regional_holidays }
  it { is_expected.to belong_to :company }
  it { is_expected.to validate_presence_of :city }

  describe '#to_s' do
    let(:office) { create :office }

    it { expect(office.to_s).to eq office.city }
  end
end
