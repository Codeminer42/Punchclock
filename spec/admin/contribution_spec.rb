require 'spec_helper'

describe Contribution do
  describe 'Contribution' do
    let(:resource) { ActiveAdmin.application.namespaces[:admin].resources[described_class] }

    it 'verifies the resource name' do
      expect(resource.resource_name).to eq 'Contribution'
    end

    it 'includes the resource in the menu' do
      expect(resource).to be_include_in_menu
    end

    it 'verifies defined actions for a resource' do
      expect(resource.defined_actions).to include :index, :show, :new, :create
    end
  end
end
