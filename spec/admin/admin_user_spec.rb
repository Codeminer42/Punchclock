require 'spec_helper'

describe AdminUser do 
  describe 'AdminUser' do
    let(:resource_class) { AdminUser }
    let(:resource) { ActiveAdmin.application.namespaces[:admin].resources[resource_class] }
    
    it 'Verify resource name' do   
      expect(resource.resource_name).to eq 'AdminUser'
    end

    it 'Verifying menu display' do
      expect(resource).to be_include_in_menu
    end

    it 'Verifying defined actions for a resource' do
      expect(resource.defined_actions).to include :index, :show
    end
  end
end
