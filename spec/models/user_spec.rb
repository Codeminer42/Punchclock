require 'spec_helper.rb'

describe User do
  describe 'relations' do
    it { is_expected.to belong_to :office }
    it { is_expected.to belong_to :reviewer }
    it { is_expected.to have_many :punches }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  describe "role" do
    it { is_expected.to define_enum_for(:role).with([:trainee, :junior, :pleno, :senior]) }
  end
end
