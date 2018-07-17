require 'spec_helper'

describe AdminUser, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :email }

    describe ':company_id' do
      context 'as a super admin' do
        subject(:super_admin_user) { build :admin_user, :super }
        it { is_expected.to_not validate_presence_of(:company_id) }
      end

      context 'as a normal admin' do
        subject { build :admin_user }
        it { is_expected.to validate_presence_of(:company_id) }
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to :company }
  end

  describe '#email' do
    let(:admin_user) { build :admin_user }
    it { expect(admin_user.to_s).to eq admin_user.email }
  end
end
