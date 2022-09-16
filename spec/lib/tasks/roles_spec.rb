require 'rails_helper'

describe 'roles' do
  Rails.application.load_tasks

  describe ':migrate_from_single_role' do
    subject { Rake::Task["roles:migrate_from_single_role"].execute }
    let!(:normal_user) { build(:user, role: 'normal', roles: []).tap { |u| u.save(validate: false) } }
    let!(:admin_user) { build(:user, role: 'admin', roles: []).tap { |u| u.save(validate: false) } }

    it { expect { subject }.not_to change { normal_user.reload.roles.values } }
    it { expect { subject }.to change { admin_user.reload.roles.values }.from(["normal"]).to(['admin']) }

    context 'when user already has a given role' do
      let!(:admin_user) { create(:user, role: 'normal', roles: ['admin']) }
      it 'updates roles' do
        expect { subject }.to change { admin_user.reload.roles.values }
          .from(['normal']).to(['admin'])
      end
    end
  end
end
