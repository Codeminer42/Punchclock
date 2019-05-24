require 'rails_helper'

describe Client do
  let(:active_client) { create :client, :active_client }
  let(:inactive_client) { create :client, :inactive_client }

  describe 'relations' do
    it { is_expected.to belong_to(:company).optional }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of :name }
  end

  describe '#enable!' do
    it 'enables a client' do
      inactive_client.enable!
      expect(inactive_client).to be_active
    end
  end

  describe '#disable!' do
    it 'disables a client' do
      active_client.disable!
      expect(active_client).not_to be_active
    end
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
