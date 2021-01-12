require 'rails_helper'

RSpec.describe ContributionsTextService do
  describe "#all" do

    context "with only one contribution" do
      let!(:user) {create(:user)}
      let!(:contribution) {create(:contribution,user: user)}

      it "returns contribution data" do
        subject = described_class.new user.contributions
        text = subject.generate
        expect(text).to include(contribution.link)
        expect(text).to include(user.name)
        expect(text).to include(user.github)
        expect(text).to include(user.office.city)
        expect(text).to include("1 PR")
        expect(text).to include("1 miner")
      end

    end

    context "with only multiple contribution from same user" do
      let!(:user) {create(:user)}
      let!(:contribution1) {create(:contribution,user: user)}
      let!(:contribution2) {create(:contribution,user: user)}
      let!(:contribution3) {create(:contribution,user: user)}

      it "returns contribution data" do
        subject = described_class.new user.contributions
        text = subject.generate
        expect(text).to include(contribution1.link)
        expect(text).to include(contribution2.link)
        expect(text).to include(contribution3.link)
        expect(text).to include(user.name)
        expect(text).to include(user.github)
        expect(text).to include(user.office.city)
        expect(text).to include("3 PR's")
        expect(text).to include("1 miner")
      end
    end

    context "with multiple users" do
      let!(:user1) {create(:user)}
      let!(:contribution1) {create(:contribution,user: user1)}
      let!(:user2) {create(:user)}
      let!(:contribution2) {create(:contribution,user: user2)}

      it "returns contribution data" do
        subject = described_class.new(Contribution.where("user_id = ? OR user_id = ?",user1.id,user2.id))
        text = subject.generate
        expect(text).to include(contribution1.link)
        expect(text).to include(user1.name)
        expect(text).to include(user1.github)
        expect(text).to include(user1.office.city)
        expect(text).to include(contribution2.link)
        expect(text).to include(user2.name)
        expect(text).to include(user2.github)
        expect(text).to include(user2.office.city)
        expect(text).to include("2 PR's")
        expect(text).to include("2 miners")
      end
    end
  end
end
