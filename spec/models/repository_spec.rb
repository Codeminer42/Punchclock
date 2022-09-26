require 'rails_helper'

RSpec.describe Repository, type: :model do
  it { is_expected.to have_many(:contributions).dependent(:nullify) }

  describe 'validations' do
    subject { build :repository }

    it { is_expected.to validate_presence_of(:link) }
    it { is_expected.to validate_uniqueness_of(:link).case_insensitive }
  end
end
