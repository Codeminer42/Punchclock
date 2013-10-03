require 'spec_helper'

describe Comment do
  it { should validate_presence_of(:company_id) }
  it { should validate_presence_of(:user_id) }
end
