require 'spec_helper'

describe Project do
  describe 'model features' do
    let(:project) { create :project }
    let(:active_project) { create :project, :active }
    let(:inactive_project) { create :project, :inactive }

    describe 'relations' do
      it { is_expected.to have_many :punches }
    end

    it { should enumerize(:market).in(%i[internal international]) }

    describe 'validations' do
      it { is_expected.to validate_presence_of :market }
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

  describe 'scopes' do
    describe '#active' do
      let(:active_project_list) { create_list :project, 5, :active }

      it 'returns only active projects' do
        expect(Project.active).to match_array(active_project_list)
      end
    end

    describe '#inactive' do
      let(:inactive_project_list) { create_list :project, 5, :inactive }

      it 'returns only inactive projects' do
        expect(Project.inactive).to match_array(inactive_project_list)
      end
    end

    describe '#by_operation' do
      let!(:active_project) { create :project, :active }
      let!(:inactive_project) { create :project, :inactive }

      it 'filters projects by its active status', :aggregate_failures do
        expect(Project.by_operation(true)).to eq([active_project])
        expect(Project.by_operation(nil)).to match_array([active_project, inactive_project])
      end
    end

    describe '#by_market' do
      let!(:internal_project) { create(:project, :internal) }
      let!(:international_project) { create(:project, :international) }

      it 'filters projects by its market', :aggregate_failures do
        expect(Project.by_market('internal')).to eq([internal_project])
        expect(Project.by_market(nil)).to match_array([internal_project, international_project])
        expect(Project.by_market('international')).to eq([international_project])
      end
    end

    describe '#by_name_like' do
      let!(:project1) { create(:project, name: 'TheFirstProject') }
      let!(:project2) { create(:project, name: 'TheSecondProject') }

      it 'filters projects by its name', :aggregate_failures do
        expect(Project.by_name_like('first')).to eq([project1])
        expect(Project.by_name_like(nil)).to match_array([project1, project2])
        expect(Project.by_name_like('second')).to eq([project2])
      end
    end
  end
end
