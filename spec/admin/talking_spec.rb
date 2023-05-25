# frozen_string_literal: true

require 'spec_helper'

describe Talking do
  describe 'Talking' do
    let(:resource) { ActiveAdmin.application.namespaces[:admin].resources[described_class] }

    it 'verifies the resource name' do
      expect(resource.resource_name).to eq 'Talking'
    end

    it 'includes the resource in the menu' do
      expect(resource).to be_include_in_menu
    end

    it 'verifies defined actions for a resource' do
      expect(resource.defined_actions).to include :index
    end
  end
end
