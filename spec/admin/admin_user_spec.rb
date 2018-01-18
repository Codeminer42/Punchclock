require 'spec_helper'

describe AdminUser do 
  describe 'AdminUser' do
    let(:resource_class) { AdminUser }
    let(:resource) { ActiveAdmin.application.namespaces[:admin].resources[resource_class] }        
    
    it 'Verify resource name' do   
      resource.resource_name.should == 'AdminUser'
    end

    it 'Verifying menu display' do
      resource.should be_include_in_menu
    end

    it 'Verifying defined actions for a resource' do
      resource.defined_actions.should =~ [:create, :new, :update, :edit, :index, :show, :destroy]
    end
  end
end
