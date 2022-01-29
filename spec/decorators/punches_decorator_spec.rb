require 'spec_helper'

describe PunchesDecorator do
  describe "#by_date" do
    it "group punches by date" do
      punch = build(:punch, from: "25/01/2022 08:00")
      punches = PunchesDecorator.new([punch])

      expect(punches.by_date).to eq "25/01/2022".to_date => [punch]
    end
  end

  describe "#total_hours" do
    it "return total regitered hours from given punches" do
      create_list(:punch, 2, from: "25/01/2022 08:00", to: "25/01/2022 12:00")
      punches = Punch.all
      punches = PunchesDecorator.new(punches)

      expect(punches.total_hours).to eq "08:00"
    end
  end
end
