require 'spec_helper.rb'

describe User do
  it { is_expected.to belong_to :reviewer }

  describe "role" do
    it { is_expected.to define_enum_for(:role).with([:trainee, :junior, :pleno, :senior]) }
  end
end
