require 'rails_helper'

RSpec.describe City, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:state) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
