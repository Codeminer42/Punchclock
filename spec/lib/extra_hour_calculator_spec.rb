require 'rails_helper'

RSpec.describe ExtraHourCalculator do

  describe '#call' do

    let(:weeks_ago) { 2.weeks.ago.to_date + 3.day }
    let(:starting_morning) { weeks_ago + 8.hours }
    let(:end_of_the_morning) { weeks_ago + 12.hours }
    let(:starting_afternoon) { weeks_ago + 13.hours }
    let(:end_of_the_afternoon) { weeks_ago + 17.hours }

    let(:admin) { create :admin_user }
    let(:company) { admin.company }

    let(:active_user_with_hour) { create(:user, :active_user) }
    let(:active_user_without_hour) { create(:user, :active_user) }
    
    let(:worked_days) { [weeks_ago.strftime("%d/%m/%Y") ] }

    before do
    
      create(:punch, from: starting_morning,          to: end_of_the_morning,             user: active_user_with_hour, company: company)
                                                      #adding an extra hour 
      create(:punch, from: starting_afternoon,        to: end_of_the_afternoon + 1.hour,  user: active_user_with_hour, company: company)
      # next day
      create(:punch, from: starting_morning + 1.day,  to: end_of_the_morning + 1.day,     user: active_user_with_hour, company: company)

      create(:punch, from: starting_morning,          to: end_of_the_morning,             user: active_user_without_hour, company: company)
      create(:punch, from: starting_afternoon,        to: end_of_the_afternoon,           user: active_user_without_hour, company: company)
      # next day
      create(:punch, from: starting_morning + 1.day,  to: end_of_the_morning + 1.day,     user: active_user_without_hour, company: company)

    end

    it 'has more than 8 hours' do
      expect(ExtraHourCalculator.call(active_user_with_hour).present?).to be_truthy
      expect(ExtraHourCalculator.call(active_user_with_hour)).to match_array([weeks_ago.strftime("%d/%m/%Y")])
    end

    it "hasn't more than 8 hours " do
      expect(ExtraHourCalculator.call(active_user_without_hour).present?).to be_falsey
    end

  end
end
