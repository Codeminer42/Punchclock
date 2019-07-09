require 'rails_helper'

describe Company do

  describe 'relations' do
    it { is_expected.to have_many :projects }
    it { is_expected.to have_many :users }
    it { is_expected.to have_many :punches }
    it { is_expected.to have_many :offices }
    it { is_expected.to have_many :clients }
  end

  xdescribe 'carrierwave upload a image with sucess' do
  end

  describe '#to_s' do
    let(:company) { create :company }

    it { expect(company.to_s).to eq company.name }
  end
end
