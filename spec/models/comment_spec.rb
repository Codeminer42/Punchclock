require 'spec_helper'

describe Comment do
  it { is_expected.to validate_presence_of(:company_id) }
  it { is_expected.to validate_presence_of(:user_id) }
end
