require 'spec_helper'

describe Api::HolidaysController, :type => :controller do
  let(:user) { create(:user) }

  describe 'GET holidays_dashboard' do
    context 'user logged' do
      before do
        login user
      end

      it 'should return holidays' do
        all_holidays = HolidaysFromOffice.perform(subject.current_user.office)
        get :holidays_dashboard
        expect(response.body).to eq(all_holidays.to_json)
      end

      it 'should be json the response' do
        get :holidays_dashboard
        expect(response.content_type).to eq "application/json"
      end
    end

    context "user isn't logged" do
      it 'should redirect to login page' do
        get :holidays_dashboard
        expect(response).to redirect_to('/users/sign_in')
      end
    end
  end
end
