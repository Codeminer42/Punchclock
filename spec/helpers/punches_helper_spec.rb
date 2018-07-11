require 'spec_helper'

describe PunchesHelper do
  describe '#secs_to_formated_hour' do
    it { expect(helper.secs_to_formated_hour(    1)).to eq '00:00' }
    it { expect(helper.secs_to_formated_hour(   60)).to eq '00:01' }
    it { expect(helper.secs_to_formated_hour(  100)).to eq '00:01' }
    it { expect(helper.secs_to_formated_hour(  200)).to eq '00:03' }
    it { expect(helper.secs_to_formated_hour(  310)).to eq '00:05' }
    it { expect(helper.secs_to_formated_hour( 1000)).to eq '00:16' }
    it { expect(helper.secs_to_formated_hour( 1040)).to eq '00:17' }
    it { expect(helper.secs_to_formated_hour( 3600)).to eq '01:00' }
    it { expect(helper.secs_to_formated_hour( 3659)).to eq '01:00' }
    it { expect(helper.secs_to_formated_hour( 3660)).to eq '01:01' }
    it { expect(helper.secs_to_formated_hour(25925)).to eq '07:12' }
  end
end
