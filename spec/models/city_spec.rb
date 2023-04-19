require 'rails_helper'

RSpec.describe City, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:state) }
    it { is_expected.to have_and_belong_to_many(:regional_holidays) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
