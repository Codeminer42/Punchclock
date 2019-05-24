# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSkill, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:skill) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:skill) }
  end
end
