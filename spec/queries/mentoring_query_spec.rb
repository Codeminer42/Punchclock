# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MentoringQuery do
  describe '#call' do
    subject(:call) { described_class.new.call }

    context 'when there are mentees and mentors' do
      let(:mentor) { create(:user) }
      let!(:mentee) { create(:user, reviewer_id: mentor.id) }

      let(:mentors) { call.map(&:mentors) }
      let(:offices) { call.map(&:city) }
      let(:mentees) { call.map(&:mentees) }

      it 'returns mentors' do
        expect(mentors).to contain_exactly(mentor.name)
      end

      it "returns mentor's office" do
        expect(offices).to contain_exactly(mentor.office.city)
      end

      it "returns mentor's mentees" do
        expect(mentees).to contain_exactly([mentee.name])
      end
    end
  end
end
