require 'spec_helper'

describe Api::HolidaysController, :type => :controller do
  let(:user) { create(:user) }

  before do
    login user
  end

  describe "GET /holidays_dashboard" do
    subject { get :holidays_dashboard }

    it { is_expected.to have_http_status(:ok) }

    it "returns content type json" do
      expect(subject.content_type).to eq "application/json"
    end

    it "returns holidays" do
      holidays = [{day: 7, month: 9}]
      allow_any_instance_of(User).to receive(:office_holidays).and_return holidays
      expect(subject.body).to eq(holidays.to_json)
    end
  end
end
