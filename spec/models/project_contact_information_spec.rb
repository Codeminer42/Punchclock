require 'rails_helper'

RSpec.describe ProjectContactInformation, type: :model do
  context 'Association' do
    it { is_expected.to belong_to(:project) }
  end

  context 'Validations' do
    subject { build :project_contact_information }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :project_id }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:project_id) }
  end
end
