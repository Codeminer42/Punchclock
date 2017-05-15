require 'spec_helper'

describe Project do
  let!(:active_project) { FactoryGirl.create(:project, :active) }
  let!(:inactive_project) { FactoryGirl.create(:project, :inactive) }


  describe '#active' do
    it 'is active' do
      expect(active_project).to be_active
    end

    it 'is inactive' do
      expect(inactive_project).to_not be_active
    end
  end
end
