# frozen_string_literal: true

require 'spec_helper'

describe Talk do
  describe 'Talk' do
    let(:resource) { ActiveAdmin.application.namespaces[:admin].resources[described_class] }
    let(:actions) { %i[index show destroy create update edit new] }

    it 'verifies the resource name' do
      expect(resource.resource_name).to eq 'Talk'
    end

    it 'includes the resource in the menu' do
      expect(resource).to be_include_in_menu
    end

    it 'verifies defined actions for a resource' do
      expect(resource.defined_actions).to eq(actions)
    end
  end
end
