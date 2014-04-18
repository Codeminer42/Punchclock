require 'spec_helper'

describe NotificationController do
  let(:notification) { create(:notification) }
  let(:user) { notification.user }
  before { login user }

  describe 'PUT update' do
    before do
      Notification.any_instance.stub(:update)
      Notification.any_instance.stub(:errors).and_return([])
      put :update, id: notification.id, notification: { read: true }
    end

    it 'should update read param' do
      response.should be_successful
    end
  end
end
