require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to :company }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'scopes' do
    it 'default active true' do
      expect(subject.active).to be true
    end
  end
end
