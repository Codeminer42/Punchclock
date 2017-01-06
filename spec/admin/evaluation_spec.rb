require 'spec_helper.rb'

describe Evaluation do
  let(:resource_class) { Evaluation }
  let(:all_resources)  { ActiveAdmin.application.namespaces[:admin].resources }
  let(:resource)       { all_resources[resource_class] }

  it { expect(resource.resource_name).to eq('Evaluation') }
  it { expect(resource).to be_include_in_menu }
  it { expect(resource.defined_actions).to contain_exactly(:index, :show) }
end
