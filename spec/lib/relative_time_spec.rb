require 'spec_helper'

RSpec.describe RelativeTime do
  describe "#relative_to" do
    it "returns build time relative to given date" do
      time = "13:00"
      date = "29/01/2022"

      relative_time = RelativeTime.new(time)

      expect(relative_time.relative_to(date)).to eq "29/01/2022 13:00".to_datetime
    end
  end

  describe ".format_seconds_in_hours" do
    it "when not full hour return hour and minute formated" do
      seconds = 5400.seconds

      expect(RelativeTime.format_seconds_in_hours(seconds)).to eq "1H30M"
    end

    it "when full hour return only hour formated" do
      seconds = 3600.seconds

      expect(RelativeTime.format_seconds_in_hours(seconds)).to eq "1H"
    end
  end
end
