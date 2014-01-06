require 'spec_helper'

describe Punch do

  it { should validate_presence_of(:from) }
  it { should validate_presence_of(:to) }
  it { should validate_presence_of(:project_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:company_id) }

  describe "#delta" do
    let(:punch) { build(:punch, from: Time.new(2014, 1, 1, 8), to: Time.new(2014, 1, 1, 12)) }

    it "returns the time difference between from and to in hours"  do
      expect(punch.delta).to eq(4.hours / 3600)
    end
  end

  context "times validation" do
    let(:project) { FactoryGirl.create(:project) }
    let(:user) { FactoryGirl.create(:user) }

    it "does not allow retroactive end date" do

      expect(Punch.new(from: Time.new(2001,2,1,8,0,0,0),
                       to: Time.new(2001,1,1,17,0,0,0),
                       project: project, user: user)).not_to be_valid
    end

    it "does not allow times from diferent days" do
      expect(Punch.new(from: Time.new(2001,1,1,8,0,0,0),
                       to:   Time.new(2001,1,2,17,0,0,0),
                       project: project, user: user)).not_to be_valid
    end
  end
end