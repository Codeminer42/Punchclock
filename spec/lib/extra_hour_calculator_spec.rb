require 'rails_helper'

RSpec.describe ExtraHourCalculator do

  describe '#call' do

    let(:weeks_ago) { Time.new(2018, 01, 17, 8, 0, 0, "+00:00")}
    let(:starting_morning) { Time.new(2018, 01, 17, 8, 0, 0, "+00:00") }
    let(:end_of_the_morning) {  Time.new(2018, 01, 17, 12, 0, 0, "+00:00") }
    let(:starting_afternoon) {  Time.new(2018, 01, 17, 13, 0, 0, "+00:00") }
    let(:end_of_the_afternoon) {  Time.new(2018, 01, 17, 17, 0, 0, "+00:00") }
    let(:end_of_the_afternoon_with_extra_hour) {  Time.new(2018, 01, 17, 19, 0, 0, "+00:00") }
    let(:admin) { create :admin_user }
    let(:company) { admin.company }
    let(:active_user_with_hour) { create(:user, :active_user) }
    let(:active_user_without_hour) { create(:user, :active_user) }
    let(:worked_days) { [weeks_ago.strftime("%d/%m/%Y") ] }

    before do
      create(:punch, from: starting_morning, to: end_of_the_morning, user: active_user_with_hour, company: company)
      #adding an extra hour
      create(:punch, from: starting_afternoon, to: end_of_the_afternoon_with_extra_hour,  user: active_user_with_hour, company: company)
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
