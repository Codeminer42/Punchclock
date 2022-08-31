require 'rails_helper'

describe 'roles' do
  Rails.application.load_tasks

  describe ':create_default_roles' do
    subject { Rake::Task["roles:create_default_roles"].execute }

    it 'creates default roles' do
      expect { subject }.to change(Role, :count).from(0).to(6)
      expect(Role.pluck(:name)).to eq(
        %w[normal evaluator admin super_admin open_source_manager hr]
      )
    end

    context 'when roles already exist' do
      before { subject }
      it 'does not create' do
        expect { subject }.not_to change(Role, :count)
      end
    end
  end
  describe ':migrate_from_single_role' do
    subject { Rake::Task["roles:migrate_from_single_role"].execute }
    let!(:normal_role) { create(:role, name: 'normal') }
    let!(:normal_user) { create(:user, role: 'normal') }
    let!(:super_admin_role) { create(:role, name: 'super_admin') }
    let!(:super_admin_user) { create(:user, role: 'super_admin') }

    it { expect { subject }.to change { normal_user.reload.roles }.from([]).to([normal_role]) }
    it { expect { subject }.to change { super_admin_user.reload.roles }.from([]).to([super_admin_role]) }

    describe 'when role does not exist' do
      let!(:admin_user) { create(:user, role: 'admin') }
      it 'raises error' do
        expect { subject }.to raise_error
      end
    end

    describe 'when user already has a given role' do
      let(:super_admin_role) { create(:role, name: 'super_admin') }
      let!(:super_admin_user) { create(:user, role: 'super_admin', roles: [super_admin_role]) }
      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
