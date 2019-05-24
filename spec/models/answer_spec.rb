# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:question) }
    it { is_expected.to belong_to(:evaluation) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:evaluation) }
    it { is_expected.to validate_presence_of(:question) }
    it { is_expected.to validate_presence_of(:response) }
  end
end
