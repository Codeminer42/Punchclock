require 'rails_helper'

RSpec.describe Note, type: :model do
  
  describe 'relations' do
    it { is_expected.to belong_to :author }
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :company }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to validate_length_of(:comment).is_at_most(500) }
    it { is_expected.to enumerize(:rate).in( %i[bad neutral good] ) }
  end
end
