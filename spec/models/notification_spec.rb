require 'spec_helper'

describe Notification do
  let(:notification) { FactoryGirl.create(:notification) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:message) }

  describe "notification has been sent from an user" do
    it "should have a from user" do
      notification.from.should_not be_nil
    end
  end
end
