require 'spec_helper'

describe User do 
  describe 'User' do
    let(:resource_class) { User }
    let(:resource) { ActiveAdmin.application.namespaces[:admin].resources[resource_class] }        
    
    it 'Verify resource name' do   
      resource.resource_name.should == 'User'
    end

    it 'Verifying menu display' do
      resource.should be_include_in_menu
    end

    it 'Verifying defined actions for a resource' do
      resource.defined_actions.should =~ [:create, :new, :update, :edit, :index, :show, :destroy]
    end
  end
end
