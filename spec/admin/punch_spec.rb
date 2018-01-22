require 'spec_helper'

describe Punch do 
  describe 'Punch' do
    let(:resource_class) { Punch }
    let(:resource) { ActiveAdmin.application.namespaces[:admin].resources[resource_class] }        
    
    it 'Verify resource name' do   
      resource.resource_name.should == 'Punch'
    end

    it 'Verifying menu display' do
      resource.should be_include_in_menu
    end

    it 'Verifying defined actions for a resource' do
      resource.defined_actions.should =~ [:create, :new, :update, :edit, :index, :show, :destroy]
    end
  end
end
