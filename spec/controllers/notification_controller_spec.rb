require 'spec_helper'

describe NotificationController do
  login_user
  let(:notification) { FactoryGirl.create(:notification) }
  let(:user) { notification.user }

  before do
    controller.stub(current_user: user)
  end

  describe "PUT update" do
    before { Notification.stub(find: notification) }

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
      response.should be_successful
    end
  end
end
