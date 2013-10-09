require 'spec_helper'

describe Notification do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:message) }
end
