require 'spec_helper'

describe AdminUser, type: :model do
  let(:admin) { FactoryBot.create(:admin_user, is_super: true) }
  describe 'relations' do
    it { is_expected.to belong_to :company }
  end

  describe 'validations' do 
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:company_id) }
  end
end
