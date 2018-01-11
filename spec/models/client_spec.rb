require 'rails_helper'

RSpec.describe Client, type: :model do

  let!(:active_client) { FactoryGirl.create(:client, :active_client) }
  let!(:inactive_client) { FactoryGirl.create(:client, :inactive_client) }

  describe 'relations' do
    it { is_expected.to belong_to :company }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'scopes' do
    it 'is active' do
      expect(active_client).to be_active
    end

    it 'is inactive' do
      expect(inactive_client).to_not be_active
    end
  end

  describe 'attribute active default' do
    it 'default active true' do
      expect(subject.active).to be true
    end
  end

end
