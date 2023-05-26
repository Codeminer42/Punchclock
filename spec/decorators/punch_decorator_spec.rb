require 'spec_helper'

describe PunchDecorator do

  describe "#extra_hour as 'no'" do 
    let(:punch) { create (:punch) }
    let(:punch_decorator) { PunchDecorator.new(punch) }

    it "translates the bool value into 'no'" do 
      expect(punch_decorator.extra_hour).to eq("#{I18n.t(false)}")
    end 
  end 

  describe "#extra_hour as 'yes'" do 
    let(:punch) { create :punch, :is_extra_hour }
    let(:punch_decorator) { PunchDecorator.new(punch) }

    it "translates the bool value into 'yes'" do 
      expect(punch_decorator.extra_hour).to eq("#{I18n.t(true)}")
    end
  end 
end
