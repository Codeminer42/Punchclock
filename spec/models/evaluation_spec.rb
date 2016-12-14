require 'spec_helper.rb'

describe Evaluation, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :reviewer }

  let(:user) { create(:user) }

  subject(:evaluation) { Evaluation.new(user_id: user.id, reviewer_id: 2, review: 'Foobar') }

  context 'with valid params' do
    it { expect(evaluation).to be_valid }
  end

  context 'with invalid params' do
    it 'invalid review' do
      evaluation.review = nil
      expect(evaluation).not_to be_valid
    end
  end
end
