# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSkill, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:skill) }
  end

  describe 'experience level' do
    it { is_expected.to enumerize(:experience_level).in(:capable, :expert).with_default(:capable) }
  end
end
