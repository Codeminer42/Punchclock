require 'spec_helper'

describe EducationExperience do
  describe 'EducationExperience' do
    let(:resource_class) { EducationExperience }
    let(:resource) { ActiveAdmin.application.namespaces[:admin].resources[resource_class] }
    
    it 'Verify resource name' do
      expect(resource.resource_name).to eq 'EducationExperience'
    end

    it 'Verifying menu display' do
      expect(resource).to be_include_in_menu
    end

    it 'Verifying defined actions for a resource' do
      expect(resource.defined_actions).to include :create, :new, :update, :edit, :index, :show, :destroy
    end
  end
end
