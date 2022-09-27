# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MentoringQuery do
  describe '#call' do
    # let(:mentors) { call.map(&:name) }
    # let(:offices) { call.map(&:city) }
    # let(:mentees) { call.map(&:mentees) }

    context 'when there are one mentee and mentor' do
      let(:mentor) { create(:user) }
      let!(:mentee) { create(:user, reviewer_id: mentor.id) }

      it 'returns mentor' do
        result = subject.call
        expect(result.map(&:name)).to contain_exactly(mentor.name)
      end

      it "returns mentor's office" do
        result = subject.call
        expect(result.map(&:office_city)).to contain_exactly(mentor.office.city)
      end

      it "returns mentor's mentee" do
        result = subject.call
        expect(result.map(&:mentees)).to contain_exactly([mentee.name])
      end
    end

    context 'when there are multiple mentees and mentors' do
      let(:mentor_1) { create(:user) }
      let(:mentor_2) { create(:user) }

      context 'and mentees are active' do
        let!(:mentor_2_mentee) { create(:user, reviewer_id: mentor_2.id) }
        let!(:other_mentor_2_mentee) { create(:user, reviewer_id: mentor_2.id) }
        let!(:mentor_1_mentee) { create(:user, reviewer_id: mentor_1.id) }
        let!(:other_mentor_1_mentee) { create(:user, reviewer_id: mentor_1.id) }

        it 'returns mentors' do
          result = subject.call
          expect(result.map(&:name)).to contain_exactly(mentor_2.name, mentor_1.name)
        end

        it "returns mentors's offices" do
          result = subject.call
          expect(result.map(&:office_city)).to contain_exactly(mentor_2.office.city, mentor_1.office.city)
        end

        it "returns mentor's mentees" do
          result = subject.call

          expect(result.flat_map(&:mentees)).to contain_exactly(
            mentor_2_mentee.name,
            other_mentor_2_mentee.name,
            mentor_1_mentee.name,
            other_mentor_1_mentee.name
          )
        end
      end

      context 'and mentee are inactive' do
        let!(:inactive_mentor_2_mentee) { create(:user, reviewer_id: mentor_1.id, active: false) }
        let!(:inactive_mentor_1_mentee) { create(:user, reviewer_id: mentor_1.id, active: false) }

        it "does not return inactive mentees" do
          result = subject.call

          expect(result.flat_map(&:mentees)).to_not contain_exactly(inactive_mentor_2_mentee, inactive_mentor_1_mentee)
        end
      end
    end

    context 'when there are no mentees or mentor' do
      before do
        create(:user)
      end

      it 'does not returns mentors' do
        expect(subject.call).to be_empty
      end

      it "does not returns mentors's offices" do
        expect(subject.call).to be_empty
      end

      it "does not returns mentor's mentees" do
        expect(subject.call).to be_empty
      end
    end
  end
end
