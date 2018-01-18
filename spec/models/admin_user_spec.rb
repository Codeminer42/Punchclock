require 'spec_helper'

describe AdminUser, type: :model do
   describe 'relations' do
    it { is_expected.to belong_to :company }
  end

  describe 'validations' do 
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:company_id) }
  end
end
