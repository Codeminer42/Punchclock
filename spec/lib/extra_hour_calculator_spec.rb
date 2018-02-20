require 'rails_helper'

RSpec.describe ExtraHourCalculator do
  include ActiveSupport::Testing::TimeHelpers

  before { travel_to(Time.zone.local(2018, 1, 18)) }

  after { travel_back }

  describe '#call' do
    let(:week_ago) { 1.week.ago }
    let(:starting_morning) { week_ago.change(hour: 8) }
    let(:end_of_the_morning) { week_ago.change(hour: 12) }
    let(:starting_afternoon) { week_ago.change(hour: 13) }
    let(:end_of_the_afternoon) { week_ago.change(hour: 17) }
    let(:end_of_the_afternoon_with_extra_hour) { week_ago.change(hour: 19) }
    let(:admin) { create :admin_user }
    let(:company) { admin.company }

    context 'user has punch with extra worker hour' do
      let(:active_user_with_hour) { create(:user, :active_user) }

      before do
        create(:punch,
               from: starting_morning,
               to: end_of_the_morning,
               user: active_user_with_hour,
               company: company)

        create(:punch,
               from: starting_afternoon,
               to: end_of_the_afternoon_with_extra_hour,
               user: active_user_with_hour,
               company: company)

        create(:punch,
               from: starting_morning + 1.day,
               to: end_of_the_morning + 1.day,
               user: active_user_with_hour,
               company: company)
      end

      it 'has the dates with extra hours' do
        expect(ExtraHourCalculator.call(active_user_with_hour)).to be_present
      end

      it 'has more than 8 hours' do
        expect(ExtraHourCalculator.call(active_user_with_hour)).to match_array([week_ago.strftime("%d/%m/%Y")])
      end
    end

    context 'user has punch without extra hour' do
      let(:active_user_without_hour) { create(:user, :active_user) }

      before do
        create(:punch,
               from: starting_morning,
               to: end_of_the_morning,
               user: active_user_without_hour,
               company: company)

        create(:punch,
               from: starting_afternoon,
               to: end_of_the_afternoon,
               user: active_user_without_hour,
               company: company)

        create(:punch,
               from: starting_morning + 1.day,
               to: end_of_the_morning + 1.day,
               user: active_user_without_hour,
               company: company)
      end

      it "hasn't more than 8 hours" do
        expect(ExtraHourCalculator.call(active_user_without_hour)).not_to be_present
      end
    end
  end
end
