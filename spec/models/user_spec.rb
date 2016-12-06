require 'spec_helper.rb'

describe User do
  it { is_expected.to belong_to :reviewer }
end
