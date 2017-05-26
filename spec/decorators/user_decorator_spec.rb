require 'spec_helper'

describe UserDecorator do
  let(:user) { create(:user_admin, hour_cost: 50) }

  describe '#hour_cost' do
    subject { user.decorate.hour_cost }

    it { is_expected.to eq('Cost: 50.0 R$/h') }
  end
end
