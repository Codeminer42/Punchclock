require 'spec_helper'

describe PunchesHelper do
  context '#secs_to_formated_hour' do
    it 'with parameter 1' do
      result =  helper.secs_to_formated_hour(1)  

      expect(result).to eq '00:00'
    end

    it 'with parameter 100' do
      result =  helper.secs_to_formated_hour(100)  

      expect(result).to eq '00:01' 
    end
  end
end

