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

  describe 'GET #show' do
    let!(:project) { create(:project) }

    before { get :show, params: { id: project.id } }

    it { is_expected.to respond_with(:ok) }

    it 'renders show template' do
      expect(response).to render_template(:show)
    end

    it 'assigns project to @project' do
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'GET #new' do
    before { get :new }

    it { is_expected.to respond_with(:ok) }

    it 'renders new template' do
      expect(response).to render_template(:new)
    end

    it 'assigns a new project to @project' do
      expect(assigns(:project)).to be_an_instance_of(Project)
    end
  end

  describe 'GET #edit' do
    let!(:project) { create(:project) }

    before do
      get :edit, params: { id: project.id }
    end

    it { is_expected.to respond_with(:ok) }

    it 'renders edit template' do
      expect(response).to render_template(:edit)
    end

    it 'assigns a new project to @project' do
      expect(assigns(:project)).to eq(project)
    end
  end

  describe 'POST #create' do
    context 'when all parameters are correct' do
      describe 'http response' do
        before do
          post :create, params: { project: { name: 'Foobar Project', market: 'internal', active: true } }
        end

        it { is_expected.to redirect_to new_admin_projects_path }
        it { is_expected.to set_flash[:notice] }
      end

      it "creates a new project" do
        expect do
          post :create, params: { project: { name: 'Foobar Project', market: 'internal', active: true } }
        end.to change(Project, :count).from(0).to(1)
      end
    end

    context 'when record is not properly saved due to name param being nil' do
      describe 'http response' do
        before do
          post :create, params: { project: { name: nil, market: 'internal', active: true } }
        end

        it { is_expected.to render_template(:new) }
        it { is_expected.to set_flash.now[:alert] }
      end
    end
  end

  describe 'PATCH #update' do
    let!(:project) { create(:project) }

    context 'when parameters are correct' do
      describe 'http response' do
        before do
          patch :update, params: { id: project.id,
                                   project: { name: 'edited project', market: 'internal', active: true } }
        end

        it { is_expected.to redirect_to new_admin_show_project_path(id: project.id) }
        it { is_expected.to set_flash[:notice] }
      end

      it "updates project" do
        expect do
          patch :update, params: { id: project.id,
                                   project: { name: 'edited project', market: 'internal', active: true } }
        end.to change { project.reload.name }.to('edited project')
      end
    end

    context 'when record is not properly updated' do
      before do
        patch :update, params: { id: project.id,
                                 project: { name: nil } }
      end

      it { is_expected.to render_template(:edit) }
      it { is_expected.to set_flash.now[:alert] }
    end
  end

  describe 'DELETE #destroy' do
    let!(:project) { create(:project) }

    context 'when record is successfully deleted' do
      describe 'http response' do
        before do
          delete :destroy, params: { id: project.id }
        end

        it { is_expected.to redirect_to new_admin_projects_path }
        it { is_expected.to set_flash[:notice] }
      end

      it "destroys project" do
        expect do
          delete :destroy, params: { id: project.id }
        end.to change(Project, :count).from(1).to(0)
      end
    end

    context 'when record is not properly deleted' do
      before do
        allow_any_instance_of(Project).to receive(:destroy).and_return(false)
        allow_any_instance_of(Project).to receive_message_chain(:errors, :full_messages).and_return(['Foobar'])

        delete :destroy, params: { id: project.id }
      end

      it { is_expected.to render_template(:index) }
      it { is_expected.to respond_with(:unprocessable_entity) }
      it { is_expected.to set_flash.now[:alert].to('Foobar') }
    end
  end
end
