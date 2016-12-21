require 'spec_helper'

describe UserDecorator do
  let(:user) { create(:user_admin, hour_cost: 50) }

  describe '#hour_cost' do
    subject { user.decorate.hour_cost }
    
    it { is_expected.to eq('Cost: 50.0 R$/h') }
  end

  describe '#admin_role?' do
    subject { user.decorate.admin_role? }

    context 'when the user is an admin' do
      it { is_expected.to eq('Sim') }
    end

    context 'when the user is not an admin' do
      let(:user) { create(:user, is_admin: false) }

      it { is_expected.to eq('Não') }
    end
  end
end
