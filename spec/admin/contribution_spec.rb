require 'spec_helper'

describe Contribution do
  describe 'Contribution' do
    let(:resource_class) { Contribution }
    let(:resource) { ActiveAdmin.application.namespaces[:admin].resources[resource_class] }

    it 'Verify resource name' do
      expect(resource.resource_name).to eq 'Contribution'
    end

    it 'Verifying menu display' do
      expect(resource).to be_include_in_menu
    end

    it 'Verifying defined actions for a resource' do
      expect(resource.defined_actions).to include :index, :show, :new, :create
    end
  end
end