# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MentoringQuery do
  describe '#call' do
    subject(:call) { described_class.new.call }

    let(:mentors) { call.map(&:name) }
    let(:offices) { call.map(&:city) }
    let(:mentees) { call.map(&:mentees) }

    context 'when there are one mentee and mentor' do
      let(:mentor) { create(:user) }
      let!(:mentee) { create(:user, reviewer_id: mentor.id) }

      it 'returns mentor' do
        expect(mentors).to contain_exactly(mentor.name)
      end

      it "returns mentor's office" do
        expect(offices).to contain_exactly(mentor.office.city)
      end

      it "returns mentor's mentee" do
        expect(mentees).to contain_exactly([mentee.name])
      end
    end

    context 'when there are multiple mentees and mentors' do
      let(:bob) { create(:user) }
      let!(:bob_mentee) { create(:user, reviewer_id: bob.id) }
      let!(:other_bob_mentee) { create(:user, reviewer_id: bob.id) }

      let(:brown) { create(:user) }
      let!(:brown_mentee) { create(:user, reviewer_id: brown.id) }
      let!(:other_brown_mentee) { create(:user, reviewer_id: brown.id) }

      context 'and mentees are active' do
        it 'returns mentors' do
          expect(mentors).to contain_exactly(bob.name, brown.name)
        end

        it "returns mentors's offices" do
          expect(offices).to contain_exactly(bob.office.city, brown.office.city)
        end

        it "returns mentor's mentees" do
          expect(mentees.flatten).to contain_exactly(bob_mentee.name, other_bob_mentee.name, brown_mentee.name, other_brown_mentee.name)
        end
      end

      context 'and mentee are inactive' do
        let!(:inactive_bob_mentee) { create(:user, reviewer_id: brown.id, active: false) }
        let!(:inactive_brown_mentee) { create(:user, reviewer_id: brown.id, active: false) }

        it "does not return inactive mentees" do
          expect(mentees.flatten).to_not contain_exactly(inactive_bob_mentee, inactive_brown_mentee)
        end
      end
    end

    context 'when there are no mentees or mentor' do
      before do
        4.times { create(:user) }
      end

      it 'does not returns mentors' do
        expect(mentors).to be_empty
      end

      it "does not returns mentors's offices" do
        expect(offices).to be_empty
      end

      it "does not returns mentor's mentees" do
        expect(mentees.flatten).to be_empty
      end
    end
  end
end
