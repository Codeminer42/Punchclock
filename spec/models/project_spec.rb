require 'spec_helper'

describe Project do
  let(:project) { create :project }
  let(:active_project) { create :project, :active }
  let(:inactive_project) { create :project, :inactive }

  describe 'relations' do
    it { is_expected.to belong_to :company }
    it { is_expected.to belong_to(:client).optional }
    it { is_expected.to have_many :punches }
  end

  describe '.active' do
    let(:active_project_list) { create_list :project, 5, :active }

    it 'returns only active projects' do
      expect(Project.active).to match_array(active_project_list)
    end
  end

  describe '.inactive' do
    let(:inactive_project_list) { create_list :project, 5, :inactive }

    it 'returns only inactive projects' do
      expect(Project.inactive).to match_array(inactive_project_list)
    end
  end

  describe '#enable!' do
    it 'enables a project' do
      inactive_project.enable!
      expect(inactive_project).to be_active
    end
  end

  describe '#disable!' do
    it 'disables a project' do
      active_project.disable!
      expect(active_project).not_to be_active
    end
  end

  describe '#to_s' do
    it { expect(project.to_s).to eq project.name }
  end
end
