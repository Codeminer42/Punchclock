require 'rails_helper'

RSpec.describe NewAdmin::ProjectsController, type: :controller do
  describe '#index' do
    let(:user) { create(:user, :admin) }

    before { sign_in(user) }

    context 'when no filter is applied' do
      let!(:projects) { create_list(:project, 3) }

      before { get :index }

      it { is_expected.to respond_with(:ok) }

      it 'renders index template' do
        expect(response).to render_template(:index)
      end

      it 'assigns decorated projects to @projects' do
        expect(assigns(:projects).last).to be_an_instance_of(ProjectDecorator)
      end
    end

    context 'when name filter is applied' do
      let!(:named_project) { create(:project, name: 'Foo Bar') }

      before do
        get :index, params: { name: 'foo' }
      end

      it 'returns project with queried name', :aggregate_failures do
        expect(assigns(:projects).count).to eq(1)
        expect(assigns(:projects).last.name).to eq(named_project.name)
      end
    end

    context 'when market filter is applied' do
      let!(:internal_project) { create(:project, :internal) }
      let!(:international_project) { create(:project, :international) }

      before do
        get :index, params: { market: 'internal' }
      end

      it 'returns internal projects' do
        expect(assigns(:projects)).to include(internal_project)
      end

      it 'filters international projects' do
        expect(assigns(:projects)).not_to include(international_project)
      end
    end

    context 'when active filter is applied' do
      let!(:active_project) { create(:project, :active) }
      let!(:inactive_project) { create(:project, :inactive) }

      before do
        get :index, params: { active: true }
      end

      it 'returns active projects' do
        expect(assigns(:projects)).to include(active_project)
      end

      it 'filters inactive projects' do
        expect(assigns(:projects)).not_to include(inactive_project)
      end
    end

    context 'when pagination is applied' do
      let!(:projects) { create_list(:project, 3) }

      it 'paginates results' do
        get :index, params: { per: 2 }

        expect(assigns(:projects).count).to eq(2)
      end
    end
  end
end
