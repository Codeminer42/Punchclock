require 'rails_helper'

describe Office do
  it { is_expected.to have_many :users }
  it { is_expected.to have_and_belong_to_many :regional_holidays }
  it { is_expected.to belong_to :company }
  it { is_expected.to validate_presence_of(:city) }

  context "with valid attributes" do
    let(:params) { { city: 'Los Angeles' } }

    it "is valid" do
      expect { Office.new(params).to be_valid }
    end
  end
end
