require 'spec_helper'

describe NotificationController do
  login_user
  let(:notification) { FactoryGirl.create(:notification) }
  let(:user) { notification.user }

  before do
    controller.stub(current_user: user)
  end

  describe "PUT update" do
    before do
      Notification.stub(find: notification)
    end

    let(:params) {
      {
        id: notification.id,
        notification: {
          read: true
        }
      }
    }

    it "should update read param" do

      notification.should_receive(:update).and_return(true)
      put :update, params
      response.code.should eq '200'
    end
  end
end
