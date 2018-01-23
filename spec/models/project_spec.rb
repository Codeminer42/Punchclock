require 'spec_helper'

describe Project do
  let!(:active_project) { FactoryBot.create(:project, :active) }
  let!(:inactive_project) { FactoryBot.create(:project, :inactive) }

  describe 'relations' do
    it { is_expected.to belong_to :company }
    it { is_expected.to belong_to :client }
    it { is_expected.to have_many :punches }
  end

  describe '.active' do
    it 'returns only active projects' do
      expect(Project.active).to match_array(active_project)
    end
  end

  describe '.inactive' do
    it 'returns only inactive projects' do
      expect(Project.inactive).to match_array(inactive_project)
    end
  end

  describe '#active' do
    it 'is active' do
      expect(active_project).to be_active
    end

    it 'is inactive' do
      expect(inactive_project).to_not be_active
    end
  end
end
