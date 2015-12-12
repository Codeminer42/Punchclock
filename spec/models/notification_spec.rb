require 'spec_helper'

describe Notification do
  let(:notification) { FactoryGirl.build(:notification) }

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:message) }

  describe 'notification has been sent from an user' do
    it 'should have a from user' do
      expect(notification.from).not_to be_nil
    end
  end

  describe 'save notification' do
    it 'should have a default event path when no path was set' do
      n = Notification.create(
        user_id: notification.user_id,
        message: notification.message
      )
      expect(n.event_path).to eq('#')
    end
  end
end
