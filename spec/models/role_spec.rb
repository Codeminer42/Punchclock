require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'validations' do
    let!(:role) { create(:role) }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'relations' do
    it { is_expected.to have_and_belong_to_many(:users) }
  end
end
