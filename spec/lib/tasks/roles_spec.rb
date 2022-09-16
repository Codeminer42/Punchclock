require 'rails_helper'

describe 'roles' do
  Rails.application.load_tasks

  describe ':migrate_from_single_role' do
    subject { Rake::Task["roles:migrate_from_single_role"].execute }
    let!(:normal_user) { build(:user, role: 'normal', roles: []).tap { |u| u.save(validate: false) } }
    let!(:super_admin_user) { build(:user, role: 'super_admin', roles: []).tap { |u| u.save(validate: false) } }

    it { expect { subject }.not_to change { normal_user.reload.roles.values } }
    it { expect { subject }.to change { super_admin_user.reload.roles.values }.from(["normal"]).to(['super_admin']) }

    context 'when user already has a given role' do
      let!(:super_admin_user) { create(:user, role: 'super_admin', roles: ['admin']) }
      it 'updates roles' do
        expect { subject }.to change { super_admin_user.reload.roles.values }
          .from(['admin']).to(['super_admin'])
      end
    end
  end
end
