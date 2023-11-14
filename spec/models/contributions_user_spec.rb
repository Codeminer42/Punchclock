require 'rails_helper'

RSpec.describe ContributionsUser, type: :model do
  context 'associations' do 
    it { is_expected.to belong_to(:contribution) }
    it { is_expected.to belong_to(:user) }
  end
end
