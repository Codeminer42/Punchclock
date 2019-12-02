# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:reviewer) }
    it { is_expected.to belong_to(:contribution) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :state }
  end

  describe 'state' do
    it 'define the possible states' do
      is_expected.to enumerize(:state).in(received: 0,
                                          approved: 1,
                                          refused: 2)
    end
  end
end
