require "spec_helper"

describe ApplicationHelper do
  describe "#time_format" do
    let(:punch) {
        Punch.new(
          from:         "2014-02-19 14:15:00",
          to:           "2014-02-19 20:20:00",
          project_id:   2,
          user_id:      1,
          company_id:   1,
        ) }

    it "returns hours:mins" do
      expect(time_format(punch.delta)).to eq('6:05')
    end
  end
end
