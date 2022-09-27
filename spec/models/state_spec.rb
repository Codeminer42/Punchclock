require 'rails_helper'

RSpec.describe State, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:cities) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:code) }
  end
end
