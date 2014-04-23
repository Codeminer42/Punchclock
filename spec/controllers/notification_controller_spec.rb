require 'spec_helper'

describe NotificationController do
  before { login user }
  let(:notification) { create :notification, user: user }
  let(:user) { create :user }

  describe 'PUT update' do
    let(:params) do
      {
        id: notification.id,
        notification: {
          read: true
        }
      }
    end

    it 'should update read param' do
      put :update, params
      expect(response).to redirect_to notification_index_path
    end
  end
end
